#!/usr/bin/ruby
require "ircbot.rb"
require "database.rb"
require "core.rb"

# $SAFE = 1

class Mud < IrcBot
  
  def connectDB(*args)
    Database.instance.connect(*args) # singleton
    @core = Core.new # insieme di funzioni x elaborare i messaggi
  end
  
  def closeDB()
    Database.instance.close
  end
  
  def parse(msg)
    # puts Thread.current
    puts msg
    if msg =~ /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      text = evaluate($1, $2, $3, $4)
      unless text.empty?
        message($1, up_case(text))
      else
        message($1, up_case(@core.cmd_not_found))
      end
    end
  end
  
  def evaluate(nick, extra, target, msg)
    msg = msg.strip
    # riconoscimento utente
    unless (@core.is_welcome? nick)
      if msg =~ /^(ciao|salve)$/i
        return @core.welcome(nick, $1)
      else
        return @core.need_welcome
      end
    end
    
    @core.update_timestamp(nick) # segnala attivita' utente
    
    # tutti i comandi
    case msg
    when /^mi\s(alzo|sveglio)$/i
      return @core.up(nick)
    when /^mi\s(siedo|addormento|sdraio|riposo|stendo|distendo)$/i
      return @core.down(nick)
    when /^dove.+(sono|siamo|finit.|trov.+)\?$/i
      return @core.place(nick)
    when /^dove.+(recar.+|andar.+|procedere|diriger.+)\?$/i
      return @core.near_place(nick)
    when /^va.*\s(ne|a).{1,3}\s(.+)$/i
      return @core.move(nick, $2)
    when /^chi.+(qu.|zona)\?$/i
      return @core.users_zone(nick)
    when /^(esamin.|guard.|osserv.|scrut.|analizz.)\s(.+)$/i
      return @core.look(nick, $2)
    when /^salva$/i
      return @core.save(nick)
    end
    return ""
  end
  
end

# Main

if __FILE__ == $0
  begin
    app = Mud.new("game_master", "Game Master")
    app.connectDB("127.0.0.1", 5432, "mud_db", "postgres", "caliostro")
    app.connectIRC("127.0.0.1", 6667)
    app.main_loop
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
    app.closeDB
  end
end
