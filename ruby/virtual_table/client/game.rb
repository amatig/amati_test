require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

class Game < EventMachine::Connection  
  attr_reader :running
  
  def initialize
    @screen = Screen.new([800,600], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @events = Rubygame::EventQueue.new
    @running = true
    #loop
  end
  
  def loop
    #Thread.new do
      #while @running
        @events.each do |ev|
          case ev
          when Rubygame::MouseDownEvent
            send_data "mario\r\n"
          when Rubygame::QuitEvent
            Rubygame.quit
            @running = false
          end
        end
      #end
    #end
  end
  
  def receive_data(data)
    puts data
  end
end


EventMachine::run do
  emc = EventMachine::connect("0.0.0.0", 8081, Game)
  EventMachine.add_periodic_timer(0.1) do
    emc.loop
    return unless emc.running
  end
end
