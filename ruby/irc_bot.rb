#!/usr/bin/ruby

require "socket"

$SAFE=1

class IRC
  
  def initialize(nick, realname)
    @delimiter = "\r\n"
    @nick = nick
    @realname = realname
  end
  
  def connect(server, port)
    @irc = TCPSocket.open(server, port)
    send "USER #{@nick} #{@nick} bla :#{@realname}#{@delimiter}NICK #{@nick}"
  end
  
  def send(s)
    @irc.send "#{s}#{@delimiter}", 0 
  end
  
  def recv(s)
    case s.strip
    when /^PING :(.+)$/i
      send "PONG :#{$1}"
    when /^:(.+)!(.+)@(.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      send "PRIVMSG #{$1} :sto dormendo..."
    end
    puts s
  end
  
  def main_loop()
    while true
      #puts 1
      return if @irc.eof
      recv(@irc.gets)
    end
  end

end


irc = IRC.new("game_master", "Game Master")
irc.connect("127.0.0.1", 6667)

begin
  irc.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  #retry # ritenta dal begin
end
