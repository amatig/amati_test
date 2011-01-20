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
    @events.enable_new_style_events
    
    @cards = Surface.load "./images/cards.jpg"    
    (0..11).each do |n|
      m = (70 * n)
      m += 2 if m != 0
      @cards.blit @screen, [n * 50, n * 10], [3 + m, 5, 70, 109]
      m += 10
    end
    
    @running = true
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
