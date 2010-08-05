#!/usr/bin/ruby

require "socket"
require "thread"
require "sqlite3"

$SAFE=1

class IRC
  
  def initialize(nick, realname)
    @nick = nick
    @realname = realname
    @mutex_send = Mutex.new
    @delim = "\r\n"
    
    Thread.abort_on_exception = true
  end
  
  def connect(server, port)
    @irc = TCPSocket.open(server, port)
    send "USER #{@nick} #{@nick} bla :#{@realname}#{@delim}NICK #{@nick}"
  end
  
  def send(s)
    @mutex_send.synchronize do
      @irc.send(s + @delim, 0)
    end
  end
  
  def parse(s)
    #puts Thread.current
    case s.strip
    when /^PING :(.+)$/i
      send "PONG :#{$1}"
    when /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      process($1, $2, $3, $4)
    end
    puts s
  end
  
  def process(user, extra, target, msg)
    send "PRIVMSG #{user} :sto dormendo..."
  end
  
  def main_loop()
    while true
      #puts "loop"
      return if @irc.eof
      Thread.new do
        parse @irc.gets
      end
    end
  end
  
end


irc = IRC.new("game_master", "Game Master")
irc.connect("127.0.0.1", 6667)

begin
  irc.main_loop
rescue Interrupt
rescue Exception => detail
  puts detail.message
  print detail.backtrace.join("\n")
  #retry # ritenta dal begin
end
