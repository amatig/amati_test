#!/usr/bin/ruby

require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

require "libs/table"
require "libs/deck"


class Game < EventMachine::Connection
  attr_reader :running
  
  def initialize
    @screen = Screen.new([800, 600], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events 
    
    send_data "mario"
    
    table = Table.new("table1")
    deck = Deck1.new
    deck.load_54
    @objects = [table, deck]
    
    @running = true
  rescue Exception => e
    p e
    exit!
  end
  
  def unbind
    @running = false
    return
  end
  
  def tick
    @events.each do |ev|
      #puts ev.inspect
      case ev
      when Rubygame::Events::MousePressed
        # @deck.picked = true if @deck.collide?(*ev.pos)
        send_data "ciao"
      when Rubygame::Events::MouseReleased
        # @deck.picked = false
      when Rubygame::Events::MouseMoved
        # @deck.move(*ev.pos) if @deck.picked
      when Rubygame::Events::QuitRequested
        unbind
      else
        #puts ev
      end
    end
    @objects.each do |o|
      o.draw(@screen)
    end
    @screen.flip
  end
  
  def receive_data(data)
    puts data
  end
  
end


EventMachine::run do
  emg = EventMachine::connect("0.0.0.0", 3333, Game)
  give_tick = proc do 
    emg.tick
    unless emg.running
      Rubygame.quit
      EventMachine::stop_event_loop
    end
    EventMachine.next_tick(give_tick)
  end
  trap("INT") do
    Rubygame.quit
    EventMachine::stop_event_loop
  end
  give_tick.call
end
