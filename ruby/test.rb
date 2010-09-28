#!/usr/bin/ruby
require "mudonline/src/lib/ircbot.rb"

class Test < IrcBot
  
  def connectIRC(*args)
    super(*args)
    
    Thread.new do
      for i in 0..100
        message("game_master", "prova")
        sleep 1
      end
      exit
    end
  end
  
  def dispatch(msg)
    puts msg
  end
  
end

# Main

if __FILE__ == $0
  begin
    n = rand(100000)
    app = Test.new("test#{n}", "test#{n}")
    app.connectIRC("127.0.0.1", 6667)
    app.main_loop
  rescue Interrupt
  rescue Exception => e
  end
end
