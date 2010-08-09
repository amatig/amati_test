#!/usr/bin/ruby

require "ircbot.rb"
require "database.rb"

$SAFE = 1

class Mud < IrcBot
  
  def initialize(nick, realname, db_name)
    super(nick, realname)
    @db = Database.new db_name
  end
  
  def parse(msg)
    #puts Thread.current
    case msg
    when /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      data = @db.process($1, $2, $3, $4)
      if data
        send data
      else
        send "PRIVMSG #{$1} :Non ho capito..."
      end
    end
    puts msg
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
