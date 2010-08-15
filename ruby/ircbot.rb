require "socket"
require "thread"

class IrcBot
  
  def initialize(nick, realname)
    @delim = "\r\n"
    
    @nick = nick
    @realname = realname
    @buffer = ""
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def socket_send()
    @mutex.synchronize do
      if not @buffer.empty?
        @irc.send(@buffer, 0)
        @buffer = ""
      end
    end
  end
  
  def send(msg)
    # puts Thread.current
    @mutex.synchronize do
      @buffer += msg + @delim
    end
  end
  
  def connect(server, port)
    @irc = TCPSocket.open(server, port)
    send "USER #{@nick} #{@nick} bla :#{@realname}#{@delim}NICK #{@nick}"
    
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
      #puts "test loop"
      msg = @irc.gets
      case msg.strip
      when /^PING :(.+)$/i
        puts "[ Server Ping ]"
        send "PONG :#{$1}"
      else
        Thread.new do
          parse msg
        end
      end
    end
  end
  
end
