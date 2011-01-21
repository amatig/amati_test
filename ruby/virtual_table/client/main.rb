#!/usr/bin/ruby

$SAFE=0

require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

require "libs/deck"


class Game < EventMachine::Connection
  attr_reader :running
  
  def initialize
    @screen = Screen.new([800,600], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events        
    @running = true
    
    @deck = Deck1.new
    @deck.load_54
    @deck.draw(@screen)
    puts @deck.size
    
    send_data "mario"
  end
  
  def unbind
    Rubygame.quit
    @running = false
  end
  
  def tick
    @events.each do |ev|
      puts ev.inspect
      case ev
      when Rubygame::Events::MousePressed
        send_data "ciao"
      when Rubygame::Events::QuitRequested
        unbind
      else
        #puts ev
      end
    end
    @screen.flip
  end
  
  def receive_data(data)
    puts data
  end
    
end


EventMachine::run do
  emg = EventMachine::connect("0.0.0.0", 3333, Game)
  timer = EventMachine.add_periodic_timer(0.1) do
    emg.tick
    unless emg.running
      timer.cancel
      EventMachine::stop_event_loop
    end
  end
  trap("INT") do
    timer.cancel
    EventMachine::stop_event_loop
  end
end
