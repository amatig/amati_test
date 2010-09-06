require "socket"
require "thread"

class IrcBot
  
  def initialize(nick, realname = "bla")
    @irc = nil
    @delim = "\r\n"
    
    @nick = nick
    @realname = realname
    @buffer = ""
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def socket_send()
    @mutex.synchronize do
      unless @buffer.empty?
        @irc.send(@buffer, 0)
        @buffer = ""
      end
    end
  end
  
  def send(msg)
    @mutex.synchronize { @buffer += "#{msg}#{@delim}" }
  end
  
  def connectIRC(server, port)
    @irc = TCPSocket.open(server, port)
    temp = "USER #{@nick} #{@nick} bla :#{@realname}#{@delim}"
    temp += "NICK #{@nick}#{@delim}"
    @irc.send(temp, 0)
    
    # buffer send loop
    Thread.new do
      while true do
        socket_send
        sleep 1
      end
    end
  end
  
  def parse(msg)
    # non implementata
  end
  
  def main_loop()
    while true
      return if @irc.eof
      msg = @irc.gets
      Thread.new do
        msg = msg.strip
        if msg =~ /^PING :(.+)$/i
          puts "[ Server ping ]"
          send "PONG :#{$1}"
        else
          parse msg
        end
      end
    end
  end
  
  # messaggi complessi
  def message(target, msg)
    send "PRIVMSG #{target} :#{msg}"
  end
  
end
