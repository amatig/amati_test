#!/usr/bin/ruby

require "ircbot.rb"
require "core.rb"

$SAFE = 1

class Mud < IrcBot
  
  def initialize(nick, realname, db_filename)
    @core = Core.new db_filename
    super(nick, realname)
  end
  
  def connect(server, port)
    super(server, port)
    
    #Thread.new do
    #  while true
    #    puts "< cose a tempo >"
    #    sleep 1
    #  end
    #end
  end
  
  def parse(msg)
    # puts Thread.current
    puts msg
    if msg =~ /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      data = evaluate($1, $2, $3, $4)
      if not data.empty?
        privmsg($1, data)
      else
        privmsg($1, @core.cmd_not_found)
      end
    end
  end
  
  def evaluate(user, extra, target, msg)
    msg = msg.strip
    # riconoscimento utente
    if msg =~ /^(ciao|salve)$/i
      return @core.welcome user if not @core.is_welcome? user
    else
      return @core.need_welcome if not @core.is_welcome? user
    end
    # tutti i comandi
    case msg
    when /^chi.+(qui|in zona)\?$/i
      return @core.get_users
    when /^mi\s(alzo|sveglio)$/i
      return @core.up user
    when /^mi\s(siedo|addormento|sdraio|riposo|stendo|distendo)$/i
      return @core.down user
    when /^dove.+(sono|sono\sfinito|mi\strovo)\?$/i
      return @core.place user
    end
    
    return ""
  end
  
end


# Main

begin
  app = Mud.new("game_master", "Game Master", "./mud.db")
  app.connect("127.0.0.1", 6667)
  app.main_loop
rescue Interrupt
rescue Exception => e
  puts "MainLoop: " + e.message
  print e.backtrace.join("\n")
  #retry # ritenta dal begin
end
