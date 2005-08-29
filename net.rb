#
# file::    net.rb
# author::  Jon A. Lambert
# version:: 2.1.0
# date::    08/26/2005
#
# This source code copyright (C) 2005 by Jon A. Lambert
# All rights reserved.
#
# Released under the terms of the TeensyMUD Public License
# See LICENSE file for additional information.
#
# The network design is based on the Mesh project NetworkService code
# which was translated almost directly from C++, warts and all, which in
# turn is based on Schmidt's Acceptor/Connector/Reactor patterns which
# may be found at http://citeseer.ist.psu.edu/schmidt97acceptor.html
# for an idea of how all these classes are supposed to interelate.

require 'socket'
#require 'fcntl'
require 'observer'

# The lineio class implements a line-orient interface for TCP sockets.
# It's a specialization of sockio.  This class is intended for line-oriented
# protocols.
#
class LineIO

  # Creates a new lineio object
  # [+sock+]    The socket which will be used
  # [+bufsize+] The size of the buffer to use (default is 8192)
  def initialize(sock, bufsize=8192)
    @sock,@bufsize=sock,bufsize
    @inbuffer = ""
    @outbuffer = ""
  end

  # read will receive a line from the socket.  A line may be terminated by
  # LF, CR, CRNUL, LFNUL, CRLF or LFCR.
  # [+return+] The number of bytes received.
  #
  # [+IOError+]  A sockets error occurred.
  # [+EOFError+] The connection has closed normally.
  def read
    #@inbuffer << @sock.sysread(@bufsize)
    @inbuffer << @sock.recv(@bufsize)
    @inbuffer.gsub!(/\r\n|\r\x00|\n\r|\r/,"\n") # hack
    pos = @inbuffer.rindex("\n")
    if pos
      msg = @inbuffer[0..pos+1]
      @inbuffer.slice!(0..pos+1)
      return msg
    end
    nil
  rescue Exception
    raise
  end

  # write will transmit a message to the socket
  # [+msg+]    The message string to be sent.
  # [+return+] false if more data to be written, true if all data written
  #
  # [+IOError+]  A sockets error occurred.
  # [+EOFError+] The connection has closed normally.
  def write(msg)
    tmp = @outbuffer + msg
    #n = @sock.syswrite(tmp)
    n = @sock.send(tmp, 0)
    # save unsent data
    @outbuffer = tmp[n..tmp.size]
    return false if @outbuffer.size > 0
    true
  rescue Exception
    @outbuffer = ""
    raise
  end

end

# The session class is a base class contains the minimum amount of
# attributes to reasonably maintain a socket session with a client.
#
class Session
  include Observable

  attr_reader :sock
  attr_accessor :accepting, :connected, :closing, :write_blocked

  # Create a new session object
  # Used when opening both an acceptor or connection.
  # [+server+]  The reactor or connector this session is associated with.
  # [+sock+]    Nil for acceptors or the socket for connections.
  # [+returns+] A session object.
  def initialize(server, sock=nil)
    @server = server  # Reactor or connector associated with this session.
    @sock = sock      # File descriptor handle for this session.
    @addr = nil       # Network address of this socket.
    @accepting=@connected=@closing=@write_blocked=false
  end

  # init is called before using the session.
  # [+returns+] true is session object properly initialized
  def init
    true
  end

  # handle_input is called when an input event occurs for this session.
  def handle_input
  end

  # handle_output is called when an output event occurs for this session.
  def handle_output
  end

  # handle_close is called when a close event occurs for this session.
  def handle_close
  end

  # handle_oob is called when an out of band data event occurs for this
  # session.
  def handle_oob
  end

  # is_readable? tests if the socket is a candidate for select read
  # {+return+] true if so, false if not
  def is_readable?
    @connected || @accepting
  end

  # is_writable? tests if the socket is a candidate for select write
  # {+return+] true if so, false if not
  def is_writable?
    @write_blocked
  end

end

# The connection class maintains a socket connection with a
# reactor and handles all events dispatched by the reactor.
#
class Connection < Session

  # Create a new connection object
  # [+server+]  The reactor this connection is associated with.
  # [+sock+]    The socket for this connection.
  # [+returns+] A connection object.
  def initialize(server, sock)
    @sockio = LineIO.new(sock)  # Object that handles low level Socket I/O
                                # Should be configurable
    @inbuffer = ""              # buffer lines waiting to be processed
    @outbuffer = ""             # buffer lines waiting to be output
    super(server, sock)
  end

  # init is called before using the connection.
  # [+returns+] true is connection is properly initialized
  def init
    @addr = @sock.getpeername
    @connected = true
    @server.register(self)
    true
  rescue Exception
    $stderr.puts "Error-Connection(init): " + $!
    $stderr.puts $@
    false
  end

  # Update will be called when the object the connection is observing
  # has notified us of a change in state or new message.
  # When a new connection is accepted in acceptor that connection
  # is passed to the observer of the acceptor which allows the client
  # to attach an observer to the connection and make the connection
  # an observer of that object.  In this case we want to keep this
  # side real simple to avoid "unnecessary foreign entanglements".
  # We simply support a message to be sent to the socket or a token
  # indicating the clent wants to disconnect this connection.
  def update(msg)
    case msg
    when :logged_out then @closing = true
    else
      sendmsg(msg)
    end
  end

  # handle_input is called to order a connection to process any input
  # waiting on its socket.  Input is parsed into lines based on the
  # occurance of the CRLF terminator and pushed into a buffer
  # which is a list of lines.  The buffer expands dynamically as input
  # is processed.  Input that has yet to see a CRLF terminator
  # is left in the connection's inbuffer.
  def handle_input
    buf = @sockio.read
    return if !buf
    @inbuffer << buf
    @inbuffer.split(/\n/).each do |ln|
      changed
      notify_observers(ln)
    end
    @inbuffer = ""
  rescue EOFError
    @closing = true
    changed
    notify_observers(:logged_out)
    delete_observers
  rescue Exception
    @closing = true
    changed
    notify_observers(:disconnected)
    delete_observers
    $stderr.puts "Error-Connection(handle_input): " + $!
    $stderr.puts $@
  end

  # handle_output is called to order a connection to process any output
  # waiting on its socket.
  def handle_output
    done = @sockio.write(@outbuffer)
    @outbuffer = ""
    if done
      @write_blocked = false
    else
      @write_blocked = true
    end
  rescue EOFError
    @closing = true
    changed
    notify_observers(:logged_out)
    delete_observers
  rescue Exception
    @closing = true
    changed
    notify_observers(:disconnected)
    delete_observers
    $stderr.puts "Error-Connection(handle_output): " + $!
  end

  # handle_close is called to when an close event occurs for this session.
  def handle_close
    @connected = false
    changed
    notify_observers(:logged_out)
    delete_observers
    @server.unregister(self)
#    @sock.shutdown   # odd errors thrown with this
    @sock.close
  rescue Exception
    $stderr.puts "Error-Connection(handle_close): " + $!
  end

  # sendmsg places a message on the Connection's output buffer.
  # [+msg+]  The message, a reference to a buffer
  def sendmsg(msg)
    @outbuffer << msg
    @write_blocked = true  # change status to write_blocked
  end

end

# The acceptor class handles client connection requests for a reactor
#
class Acceptor < Session

  # Create a new acceptor object
  # [+server+]  The reactor this acceptor is associated with.
  # [+port+]    The port this acceptor will listen on.
  # [+returns+] An acceptor object
  def initialize(server, port)
    @port = port
    super(server)
  end

  # init is called before using the acceptor
  # [+returns+] true is acceptor is properly initialized
  def init
    # Open a socket for the server to listen on.
    @sock = TCPServer.new('0.0.0.0', @port)
    #@sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    #@sock.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, 0)
    #@sock.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
    @accepting = true
    @server.register(self)
  rescue Exception
    $stderr.puts "Error-Acceptor(init): " + $!
    $stderr.puts $@
  end

  # handle_input is called when an pending connection occurs on the
  # listening socket's port.  This function creates a Connection object
  # and calls it's init routine.
  def handle_input
    sckt = @sock.accept
    if sckt
      #sckt.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
      c = Connection.new(@server, sckt)
      if c.init
        $stdout.puts "Connection #{sckt.inspect} accepted."
        changed
        notify_observers(c)
      else
        raise "Error initializing connection on #{sckt.inspect}."
      end
    else
      raise "Error in accepting connection."
    end
  rescue Exception
    $stderr.puts "Error-Acceptor(handle_input): " + $!
    $stderr.puts $@
  end

  # handle_close is called when a close event occurs for this acceptor.
  def handle_close
    @accepting = false
    @server.unregister(self)
    @sock.close
  rescue Exception
    $stderr.puts "Error-Acceptor(handle_close): " + $!
    $stderr.puts $@
  end

end

#
# The Reactor class defines a representation of a multiplexer.
# It defines the traditional non-blocking select() server.
class Reactor

  # Constructor for Reactor
  # [+port+] The port the server will listen on.
  def initialize(port)
    @port = port       # port server will listen on
    @shutdown = false  # Flag to indicate that server is shutting down.
    @acceptor = nil    # Listening socket for incoming connections.
    @registry = []     # list of sessions
  end

  # Start initializes the reactor and gets it ready to accept incoming
  # connections.
  # [+engine+] The client engine that will be observing the acceptor.
  # [+return+'] true if server boots correctly, false if an error occurs.
  def start(engine)
    # Create an acceptor to listen for this server.
    @acceptor = Acceptor.new(self, @port)
    return false if !@acceptor.init
    @acceptor.add_observer(engine)
    true
  end

  # stop requests each of the connections to disconnect in the
  # server's user list, deletes the connections, and erases them from
  # the user list.  It then closes its own listening port.
  def stop
    @registry.each {|s| s.closing = true}
    @acceptor.delete_observers
    $stdout.puts "INFO-Reactor(shutdown): Reactor shutting down"
  end

  # poll starts the Reactor running to process incoming connection, input and
  # output requests.  It also executes commands from input requests.
  # [+tm_out*] time to poll in seconds
  def poll(tm_out)
    # Reset our socket interest set
    infds = [];outfds = [];oobfds = []
    @registry.each do |s|
      if s.is_readable?
        infds << s.sock
        oobfds << s.sock
      end
      if s.is_writable?
        outfds << s.sock
      end
    end

    # Poll our socket interest set
    infds,outfds,oobfds = select(infds, outfds, oobfds, tm_out)

    # Dispatch events to handlers
    @registry.each do |s|
      s.handle_output if outfds && outfds.include?(s.sock)
      s.handle_oob if oobfds && oobfds.include?(s.sock)
      s.handle_input if infds && infds.include?(s.sock)
      s.handle_close if s.closing
    end
  rescue
    $stderr.puts "ERROR-Reactor(select): " + $!
    $stderr.puts $@
    raise
  end

  # register adds a session to the registry
  # [+session+]
  def register(session)
    @registry << session
  end

  # unregister removes a session from the registry
  # [+session+]
  def unregister(session)
    @registry.delete(session)
  end

end
