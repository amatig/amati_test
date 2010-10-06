#!/usr/bin/ruby
require "rubygems"
require "IRC"

require "lib/database.rb"
require "core.rb"


class Master < IRC
  
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
    
    @core = Core.new # insieme di funzioni x elaborare i comandi
  end
  
  def parse(event)
    puts Thread.current
    target = (event.channel == @nick) ? event.from : event.channel
    msg = event.message
    
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
      when /^va.*\s(ne|a).{1,3}\s(.+)$/i
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
end


# Main

if __FILE__ == $0
  begin
    Database.instance.connect("127.0.0.1", 5432, "mud_db", "postgres")
    Master.new("GameMaster", "127.0.0.1", 6667, ["\#Hall"]).connect
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
    Database.instance.close
  end
end
