#
# file::    connector.rb
# author::  Jon A. Lambert
# version:: 2.6.0
# date::    09/30/2005
#
# This source code copyright (C) 2005 by Jon A. Lambert
# All rights reserved.
#
# Released under the terms of the TeensyMUD Public License
# See LICENSE file for additional information.
#

require 'fcntl'

require 'net/session'
require 'net/connection'

# The Connector class handles outgoing connections
#
class Connector < Session
  logger 'DEBUG'

  # Create a new Connector object
  # [+server+]  The reactor this Connector is associated with.
  # [+address+] The address to connect to.
  # [+returns+] An Connector object
  def initialize(server, address)
    @address = address
    super(server)
  end

  # init is called before using the Connector
  # [+returns+] true is acceptor is properly initialized
  def init
    # Open a socket for the server to connect on.
    @sock = TCPSocket.new(@address , @server.port)
    #@sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    #@sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, 0)
    unless RUBY_PLATFORM =~ /win32/
      @sock.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    end
    c = Connection.new(@server, @sock)
    if c.init
      log.info "(#{c.object_id}) Connection made."
      publish(c)
      true
    else
      false
    end
  rescue Exception
    log.error "Connector#init"
    log.error $!
    false
  end

  # handle_close is called when a close event occurs for this Connector.
  def handle_close
    @sock.close
  rescue Exception
    log.error "Connector#handle_close"
    log.error $!
  end

end

