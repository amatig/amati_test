#!/usr/local/bin/ruby

require "socket"

# Don't allow use of "tainted" data by potentially dangerous operations
$SAFE=1

# The irc class, which talks to the server and holds the main event loop
class Client
  
  def initialize(server, port)
    @server = server
    @port = port
  end
  
  def send(s)
    # Send a message to the irc server and print it to the screen
    @irc.send "#{s}\r\n", 0 
  end
  
  def connect()
    # Connect to the IRC server
    @irc = TCPSocket.open(@server, @port)
    send "user_#{rand(1000)}"
  end
  
  def handle_server_input(s)
    # This isn't at all efficient, but it shows what we can do with Ruby
    # (Dave Thomas calls this construct "a multiway if on steroids")
    case s.strip
    when /^PING :(.+)$/i
      puts "[ Server ping ]"
      send "PONG :#{$1}"
    else
      puts s
    end
  end
  
  def main_loop()
    # Just keep on truckin' until we disconnect
    while true
      ready = select([@irc, $stdin], nil, nil, nil)
      next if !ready
      for s in ready[0]
        if s == $stdin then
          puts "qui"
          return if $stdin.eof
          s = $stdin.gets
          send s
        elsif s == @irc then
          puts "la"
          return if @irc.eof
          s = @irc.gets
          handle_server_input(s)
        end
      end
    end
  end
end


# The main program
# If we get an exception, then print it out and keep going (we do NOT want
# to disconnect unexpectedly!)
cl = Client.new('0.0.0.0', 8081)
cl.connect()
begin
  cl.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end
