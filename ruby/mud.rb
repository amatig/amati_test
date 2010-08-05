#!/usr/bin/ruby

require "ircbot.rb"
require "database.rb"

$SAFE=1

class Mud < IrcBot
  
  def initialize(db_name, nick, realname)
    @db = Database.new db_name
    super(nick, realname)
  end
  
  def parse(s)
    #puts Thread.current
    case s
    when /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      info = @db.process($1, $2, $3, $4)
      if info
        send info
      else
        send "PRIVMSG #{$1} :Non ho capito..."
      end
    end
    puts s
  end
  
end


app = Mud.new("mud.db", "game_master", "Game Master")
app.connect("127.0.0.1", 6667)

begin
  app.main_loop
rescue Interrupt
rescue Exception => detail
  puts detail.message
  print detail.backtrace.join("\n")
  #retry # ritenta dal begin
end
