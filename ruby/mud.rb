#!/usr/bin/ruby

require "ircbot.rb"
require "database.rb"

$SAFE = 1

class Mud < IrcBot
  
  def initialize(nick, realname, db_name)
    @db = Database.new db_name
    super(nick, realname)
  end
  
  def connect(server, port)
    super(server, port)
    Thread.new do
      while true
        puts "< cose a tempo >"
        sleep 2
      end
    end
  end
  
  def parse(msg)
    # puts Thread.current
    data = ""
    case msg
    when /^:(.+)!(.+@.+)\sPRIVMSG\s(.+)\s:(.+)$/i
      begin
        data = process($1, $2, $3, $4)
      rescue Exception => detail
        puts detail.message
      end
      if not data.empty?
        send "PRIVMSG #{$1} :#{data}"
      else
        begin
          send "PRIVMSG #{$1} :" + @db.cmd_not_found
        rescue Exception => detail
          puts detail.message
        end
      end
    end
    puts msg
  end
  
  def process(user, extra, target, msg)
    msg = msg.strip
    if /^ciao$/i.match(msg)
      return @db.welcome user if not @db.is_welcome? user
    else
      return @db.need_welcome if not @db.is_welcome? user
    end
    
    case msg
    when /^chi.*qui\?$/i
      return @db.get_users
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
