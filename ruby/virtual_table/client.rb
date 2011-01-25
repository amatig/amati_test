#!/usr/bin/ruby

require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

require "libs/msg"
require "libs/table"
require "libs/deck"

$DELIM = "\r\n"

class Game < EventMachine::Connection
  attr_reader :running
    
  def initialize
    @screen = Screen.new([800, 600], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events
    
    @table = nil
    @objects = []
    @hash_objects = {}
    
    @picked = nil
    @accepted = false
    @running = true
    
    @nick = "user_#{rand 1000}"
    send_msg(Msg.dump(:type => "Nick", :data => @nick))
    
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
            send_msg(Msg.dump(:type => "Pick", :oid => o.oid, :args => ev.pos))
            break
          end
        end
      when Rubygame::Events::MouseReleased
        if @picked
          send_msg(Msg.dump(:type => "UnLock", :oid => @picked.oid))
          @picked = nil
        end
      when Rubygame::Events::MouseMoved
        if @picked
          move = @picked.move(*ev.pos)
          if move
            send_msg(Msg.dump(:type => "Move", :oid => @picked.oid, :args => move))
          end
        end
      when Rubygame::Events::QuitRequested
        unbind
      else
        #puts ev.inspect
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
  
  def send_msg(msg)
    msg = "#{msg}#{$DELIM}" unless msg =~ /#{$DELIM}$/
    send_data(msg)
  end
  
  def receive_data(data)
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Object"
        if m.data.kind_of?(Table)
          @table = m.data.init
        elsif m.data.kind_of?(Array)
          @objects = m.data
          @objects.each do |o| 
            o.init
            @hash_objects[o.oid] = o
          end
        end
        @accepted = true
      when "Move"
        @hash_objects[m.oid].set_pos(*m.args)
      when "Pick"
        @picked = @objects.delete(@hash_objects[m.oid])
        @objects.push(@picked)
        @picked.pick_pos(*m.args)
      when "Lock"
        temp = @objects.delete(@hash_objects[m.oid])
        @objects.push(temp)
        temp.lock = m.data
      when "UnLock"
        @hash_objects[m.oid].lock = nil
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
    # Rubygame.quit
    EventMachine::stop_event_loop
  end
  give_tick.call
end
