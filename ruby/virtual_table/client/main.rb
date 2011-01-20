#!/usr/bin/ruby

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
    send_data "mario"
  end
  
  def unbind
    Rubygame.quit
    @running = false
  end
  
  def tick
    @events.each do |ev|
      #puts ev
      case ev
      when Rubygame::MouseDownEvent
        send_data "ciao"
      when Rubygame::QuitEvent
        unbind
      else
        #puts ev
      end
    end
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
