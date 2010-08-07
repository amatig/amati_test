require "socket"
require "thread"

class IrcBot
  
  def initialize(nick, realname)
    @nick = nick
    @realname = realname
    
    @buffer = ""
    @delim = "\r\n"
    @mutex = Mutex.new
    
    Thread.abort_on_exception = true
    Thread.new do
      while true do
        real_send
        sleep 1.5
      end
    end
  end
  
  def real_send
    @mutex.synchronize do
      if @buffer != ""
        #puts @buffer
        @irc.send(@buffer, 0)
        @buffer = ""
      end
    end
  end
  
  def connect(server, port)
    @irc = TCPSocket.open(server, port)
    send "USER #{@nick} #{@nick} bla :#{@realname}#{@delim}NICK #{@nick}"
  end
  
  def send(s)
    #puts Thread.current
    @mutex.synchronize do
      # @irc.send(s + @delim, 0)
      @buffer += s + @delim
    end
  end
  
  def parse(s)
    # da implementare
  end
  
  def main_loop()
    while true
      return if @irc.eof
      Thread.new do
        #puts "test loop"
        s = @irc.gets
        case s.strip
        when /^PING :(.+)$/i
          puts "[ Server Ping ]"
          send "PONG :#{$1}"
        else
          parse s
        end
      end
    end
  end
  
end
