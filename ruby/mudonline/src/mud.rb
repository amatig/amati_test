#!/usr/bin/ruby
require "rubygems"
require "IRC"
require "lib/database.rb"
require "core.rb"

# = Description
# Classe principale del mud che usa Ruby-IRC, un framework di connessione e comunicazione con server Irc.
#
# Questa classe si occupa di distinguere, eseguire e rispondere ai comandi degli utenti, e' stata scissa 
# in due con la classe Core che elabora realmente i dati di un comando e ritorna il messaggio generato per 
# l'invio all'utente attraverso il server Irc.
#
# Nello script di main viene anche inizializzato il singleton Database per la connessione ai dati su server Postgres.
#
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

class Mud < IRC
  
  # Metodo di inizializzazione della classe.
  # Istanzia inoltre la classe Core che ha al suo interno
  # l'elaborazione dati dei comandi e la messaggistica di ritorno del mud.
  def initialize(nick, server, port, channels = [], options = {})
    super(nick, server, port, nil, options)
    # Callbakcs for the connection.
    IRCEvent.add_callback("endofmotd") do |event| 
      channels.each { |chan| add_channel(chan) }
    end
    IRCEvent.add_callback("nicknameinuse") do |event| 
      ch_nick("RubyBot")
    end
    IRCEvent.add_callback("privmsg") do |event| 
      parse(event)
    end
    IRCEvent.add_callback("join") do |event| 
      if @autoops.include?(event.from)
        op(event.channel, event.from)
      end
    end
    @core = Core.new
  end
  
  def parse(event)
    if event.channel == @nick
      delivery_priv(event.from, event.message)
    else
      delivery_chan(event.channel, event.message)
    end
  end
  
  def delivery_chan(target, msg)
  end
  
  def delivery_priv(target, msg)
    puts Thread.current
    # riconoscimento utente
    unless (@core.is_welcome? target)
      if msg =~ /^(ciao|salve)$/i
        send_message(target, @core.welcome(target, $1))
      else
        send_message(target, @core.need_welcome)
      end
    else
      @core.update_timestamp(target) # segnala attivita' utente      
      # tutti i comandi
      case msg
      when /^mi\s(alzo|sveglio)$/i
        send_message(target, @core.up(target))
      when /^mi\s(siedo|addormento|sdraio|riposo|stendo|distendo)$/i
        send_message(target, @core.down(target))
      when /^dove.+(sono|siamo|finit.|trov.+)\?$/i
        send_message(target, @core.place(target))
      when /^dove.+(recar.+|andar.+|procedere|diriger.+)\?$/i
        send_message(target, @core.near_place(target))
      when /^va.*\s(ne|a).{0,3}\s(.+)$/i
        send_message(target, @core.move(target, $2))
      when /^chi.+(qu.|zona)\?$/i
        send_message(target, @core.users_zone(target))
      when /^(esamin.|guard.|osserv.|scrut.|analizz.)\s(.+)$/i
        send_message(target, @core.look(target, $2))
      when /^salva$/i
        send_message(target, @core.save(target))
      else
        send_message(target, @core.cmd_not_found)
      end
    end
  end
  
  def send_message(target, msg)
    super(target, up_case(msg))
  end
  
  private :delivery_priv, :delivery_chan
end


# Main

if __FILE__ == $0
  begin
    Database.instance.connect("127.0.0.1", 5432, "mud_db", "postgres")
    Mud.new("GameMaster", "127.0.0.1", 6667, ["\#Hall"]).connect
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
    Database.instance.close
  end
end
