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
    if msg =~ /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      data = evaluate($1, $2, $3, $4)
      if not data.empty?
        send "PRIVMSG #{$1} :#{data}"
      else
        temp = @core.cmd_not_found
        send "PRIVMSG #{$1} :#{temp}" if not temp.empty?
      end
    end
    puts msg
  end
  
  def evaluate(user, extra, target, msg)
    msg = msg.strip
    if msg =~ /^ciao$/i
      return @core.welcome user if not @core.is_welcome? user
    else
      return @core.need_welcome if not @core.is_welcome? user
    end
    
    # tutti i comandi
    case msg
    when /^chi.*qui\?$/i
      return @core.get_users
    when /^mi alzo|mi sveglio$/i
      return @core.up user
    when /^mi siedo|dormo|mi sdraio|mi riposo|mi distendo$/i
      return @core.down user
    end
    
    return ""
  end
  
end


app = Mud.new("game_master", "Game Master", "./mud.db")
app.connect("127.0.0.1", 6667)

begin
  app.main_loop
rescue Interrupt
rescue Exception => detail
  puts detail.message
  print detail.backtrace.join("\n")
  #retry # ritenta dal begin
end
