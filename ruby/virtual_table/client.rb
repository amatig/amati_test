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
  
  def send_msg(msg)
    send_data("#{msg}\r\n")
  end
  
  def initialize
    @screen = Screen.new([800, 600], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events 
    
    send_msg("user_#{rand 1000}")
    
    @table = nil
    @objects = []
    @picked = nil
    @accepted = false
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
        @objects.reverse.each do |o|
          if o.collide?(*ev.pos)
            @picked = o
            break
          end
        end
        #send_msg "ciao"
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
      when "Object"
        if m.data.kind_of?(Table)
          @table = m.data
          @table.init
        elsif m.data.kind_of?(Array)
          @objects = m.data
          @objects.each do |o|
            o.init
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
    #Rubygame.quit
    EventMachine::stop_event_loop
  end
  give_tick.call
end
