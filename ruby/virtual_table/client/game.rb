require "rubygems"
require "eventmachine"
require"rubygame"
include Rubygame

class Game < EventMachine::Connection
  
  # attr_accessor :q
  
  def initialize
    @screen = Screen.new([800,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @q = Rubygame::EventQueue.new
  end
  
  def run
    @q.each do |ev|
      puts ev
      case ev
      when Rubygame::QuitEvent
        Rubygame.quit
        #return
        end
    end
  end
  
  def receive_data data
    puts data
  end
end

EventMachine::run do
  emc = EventMachine::connect("0.0.0.0", 8081, Game)
  EventMachine.add_periodic_timer(0.5) do
    emc.send_data "mario\r\n"
    emc.run
  end
end

#main_game = Game.new
#main_game.run
