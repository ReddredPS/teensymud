#
# file::    protocolstack.rb
# author::  Jon A. Lambert
# version:: 2.6.0
# date::    10/04/2005
#
# This source code copyright (C) 2005 by Jon A. Lambert
# All rights reserved.
#
# Released under the terms of the TeensyMUD Public License
# See LICENSE file for additional information.
#

require 'logger'

require 'protocol/filter'
require 'protocol/telnetfilter'
require 'protocol/debugfilter'
require 'protocol/colorfilter'
require 'protocol/terminalfilter'


# The ProtocolStack class implements a stack of input and output filters.
# It also maintains some interesting state variables that are shared
# amongst filters.  It keeps its own log.
#
# Remarks:: This should have its own configuration file.
#
class ProtocolStack
  attr_accessor :echo_on, :binary_on, :zmp_on, :color_on, :urgent_on, :hide_on
  attr_accessor :terminal, :twidth, :theight
  attr :conn
  attr :log

  # Construct a ProtocolStack
  #
  # [+conn+] The connection associated with this filter
  def initialize(conn, opts)
    @conn,@opts = conn,opts
    if @opts.include? :client
      @log = Logger.new('logs/protocol_client_log', 'daily')
      @log.datetime_format = "%Y-%m-%d %H:%M:%S "
    else
      @log = Logger.new('logs/protocol_log', 'daily')
      @log.datetime_format = "%Y-%m-%d %H:%M:%S "
    end
    @filters = []  # Filter order is critical as lowest level protocol is first.
    if @opts.include? :debugfilter
      @filters << DebugFilter.new(self)
    end
    if @opts.include? :telnetfilter
      @filters << TelnetFilter.new(self,@opts)
    end
    if @opts.include? :terminalfilter
      @filters << TerminalFilter.new(self)
    end
    if @opts.include? :colorfilter
      @filters << ColorFilter.new(self)
    end
    if @opts.include? :filter
      @filters << Filter.new(self)
    end

    # Shared variables to facilitate inter-filter communication.
    @sga_on = false
    @echo_on = false
    @binary_on = false
    @zmp_on = false
    @color_on = false
    @urgent_on = false
    @hide_on = false
    # This is a hack as set(:terminal, "vt100") is too late from client session.
    if @opts.include? :vt100
      @terminal = "vt100"
    else
      @terminal = nil
    end
    @twidth = 80
    @theight = 23
  end

  # A method is called on each filter in the stack in order.
  #
  # [+method+]
  # [+args+]
  def filter_call(method, args)
    case method
    when :filter_in, :init
      retval = args
      @filters.each do |v|
        retval = v.send(method,retval)
      end
    when :filter_out
      retval = args
      @filters.reverse_each do |v|
        retval = v.send(method,retval)
      end
    else
      log.error "(#{self.object_id}) ProtocolStack#filter_call unknown method '#{method}',a:#{args.inspect},r:#{retval.inspect}"
    end
    retval
  end

  # The filter_query method returns state information for the filter.
  # [+attr+]    A symbol representing the attribute being queried.
  # [+return+] An attr/value pair or false if not defined in this filter
  def query(attr)
    case attr
    when :terminal
      retval =  [:terminal, @terminal]
    when :termsize
      retval =  [:termsize, [@twidth, @theight]]
    when :color
      retval =  [:color, @color_on]
    when :zmp
      retval =  [:zmp, @zmp_on]
    when :echo
      retval =  [:echo, @echo_on]
    when :binary
      retval =  [:binary, @binary_on]
    when :urgent
      retval =  [:urgent, @urgent_on]
    when :hide
      retval =  [:hide, @hide_on]
    else
      log.error "(#{self.object_id}) ProtocolStack#query unknown setting '#{pair.inspect}'"
      retval = false
    end
    log.debug "(#{self.object_id}) ProtocolStack#query called '#{attr}',r:#{retval.inspect}"
    retval
  end

  # The filter_set method sets state information on the filter.
  # [+pair+]   An attr/value pair [:symbol, value]
  # [+return+] true if attr not defined in this filter, false if not
  def set(attr, value)
    case attr
    when :color
      @color_on = value
      true
    when :urgent
      @urgent_on = value
      true
    when :hide
      @hide_on = value
      true
    when :terminal
      @terminal = value
      true
    when :termsize
      @twidth = value[0]
      @theight = value[1]
      # telnet filter always first except when debugfilter on
      if @opts.include? :telnetfilter
        if @opts.include? :debugfilter
          @filters[1].send_naws
        else
          @filters[0].send_naws
        end
      end
      true
    when :init_subneg
      # telnet filter always first except when debugfilter on
      if @opts.include? :telnetfilter
        if @opts.include? :debugfilter
          @filters[1].init_subneg
        else
          @filters[0].init_subneg
        end
      end
      true
    else
      log.error "(#{self.object_id}) ProtocolStack#set unknown setting '#{attr}=#{value}'"
      false
    end
    log.debug "(#{self.object_id}) ProtocolStack#set called '#{attr}=#{value}'"
  end


end

