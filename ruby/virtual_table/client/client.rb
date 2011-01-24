#!/usr/bin/ruby

require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

require "libs/msg"
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
    
    send_data("user_#{rand 1000}")
    
    @table = nil
    @objects = []
    @accepted = false
    @running = true
    @picked = nil
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
        @objects.each do |o|
          @picked = o if o.collide?(*ev.pos)
        end
        p @picked
        #send_data "ciao"
      when Rubygame::Events::MouseReleased
        @picked = nil
      when Rubygame::Events::MouseMoved
        @picked.move(*ev.pos) if @picked
      when Rubygame::Events::QuitRequested
        unbind
      else
        #puts ev
      end
    end
    if @accepted
      @table.draw(@screen)
      @objects.each do |o|
        o.draw(@screen)
      end
      @screen.flip
    end
  end
  
  def receive_data(data)
    data.split("\r\n").each do |str|
      m = Msg.load(str)
      case m.type
      when "init"
        if m.data.kind_of?(Table)
          @table = m.data
          @table.init
        elsif m.data.kind_of?(Array)
          @objects = m.data
          @objects.each do |o|
            o.init
            #o.load_54
          end
        end
        @accepted = true
      end
    end
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
