#!/usr/bin/ruby

require "socket"

# Don't allow use of "tainted" data by potentially dangerous operations
$SAFE=1

# The irc class, which talks to the server and holds the main event loop
class IRC
  
  def initialize(nick, realname)
    @delimiter = "\r\n"
    @nick = nick
    @realname = realname
  end
  
  def connect(server, port)
    # Connect to the IRC server
    @irc = TCPSocket.open(server, port)
    send "USER #{@nick} #{@nick} bla :#{@realname}#{@delimiter}NICK #{@nick}"
  end
  
  def send(s)
    # Send a message to the irc server and print it to the screen
    puts "--> #{s}"
    @irc.send "#{s}#{@delimiter}", 0 
  end
  
  def handle_server_input(s)
    # This isn't at all efficient, but it shows what we can do with Ruby
    # (Dave Thomas calls this construct "a multiway if on steroids")
    case s.strip
    when /^PING :(.+)$/i
      puts "[ Server ping ]"
      send "PONG :#{$1}"
    when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:(.+)$/i
      send "PRIVMSG #{$1} :sto dormendo..."
    else
      puts s
    end
  end
  
  def evaluate(s)
    # Make sure we have a valid expression (for security reasons), and
    # evaluate it if we do, otherwise return an error message
    if s =~ /^[-+*\/\d\s\eE.()]*$/ then
      begin
        s.untaint
        return eval(s).to_s
      rescue Exception => detail
        puts detail.message()
      end
    end
    return "Error"
  end
    
  def main_loop()
    # Just keep on truckin' until we disconnect
    while true
      ready = select([@irc, $stdin], nil, nil, nil)
      next if !ready
      for s in ready[0]
        if s == $stdin then
          return if $stdin.eof
          s = $stdin.gets
          send s
        elsif s == @irc then
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
irc = IRC.new("game_master", "Game Master")
irc.connect("127.0.0.1", 6667)

begin
  irc.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end
