require "socket"
require "thread"

# = Description
# ...
# = License
# Nemesis - IRC Mud Multiplayer Online totalmente italiano
#
# Copyright (C) 2010 Giovanni Amati
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
# = Authors
# Giovanni Amati

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
  
  def connectIRC(server = "127.0.0.1", port = 6667)
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
