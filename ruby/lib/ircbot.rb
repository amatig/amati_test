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
  
  # Metodo di inizializzazione della classe.
  def initialize(nick, realname = "bla")
    @irc = nil
    @delim = "\r\n"
    
    @nick = nick
    @realname = realname
    @buffer = ""
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  # E' il metodo che effettua il vero e proprio invio dei dati
  # nel buffer sul socket svuotando il buffer alla fine dell'operazione.
  def socket_send()
    @mutex.synchronize do
      unless @buffer.empty?
        @irc.send(@buffer, 0)
        @buffer = ""
      end
    end
  end
  
  # Consente di bufferizzare i messaggi da inviare, in
  # maniera che il loop di invio svuoti il buffer ogni tot
  # per ottimizzare il blocco di messaggi da inviare al server irc.
  def send(msg)
    @mutex.synchronize { @buffer += "#{msg}#{@delim}" }
  end
  
  # Apre una connessione socket verso un server irc e
  # invia i dati identificativi per l'utente bot.
  def connectIRC(server = "127.0.0.1", port = 6667)
    @irc = TCPSocket.open(server, port)
    temp = "USER #{@nick} #{@nick} bla :#{@realname}#{@delim}"
    temp += "NICK #{@nick}#{@delim}"
    @irc.send(temp, 0)
    
    # thread loop che svuota il buffer dei messaggi da inviare
    Thread.new do
      while true do
        socket_send
        sleep 1
      end
    end
  end
  
  # Questo metodo riceve in un nuovo thread i messaggi che
  # arrivano dal socket. E' un metodo non implementato,
  # estendendo la classe ognuno lo implementa in base alla
  # logica da asegnare ad ogni messaggio
  def dispatch(msg)
    
  end
  
  # Fa partire il ciclo principale del bot che legge i messaggi
  # provenienti dal socket e li manda ad un nuovo thread 
  # chiamando il metodo dispatch.
  #
  # Nel caso si tratta di un PING del server risponde subito col
  # PONG per non far cadere la connessione.
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
          dispatch msg
        end
      end
    end
  end
  
  # Invia un messaggio di tipo PRIVMSG ad un nick/channel.
  # Questo metodo utilizza il metodo send.
  def message(target, msg)
    send "PRIVMSG #{target} :#{msg}"
  end
  
  private :socket_send
  protected :dispatch, :send
end
