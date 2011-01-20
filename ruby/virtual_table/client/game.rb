require "rubygems"
require"rubygame"
include Rubygame

class Game
  
  def initialize
    @screen = Screen.new([800,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @q = Rubygame::EventQueue.new
  end
  
  def run
    loop do
      @q.each do |ev|
        #puts ev
        case ev
        when Rubygame::QuitEvent
          Rubygame.quit
          return
        end
      end
    end
  end
  
end

main_game = Game.new
main_game.run
