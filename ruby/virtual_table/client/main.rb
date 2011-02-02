#!/usr/bin/ruby

require "rubygems"
require "eventmachine"
require "singleton"
require "rubygame"
include Rubygame

require "libs/env"
require "libs/msg"
require "libs/vobject"
require "libs/table"
require "libs/deck"
require "libs/card"
require "libs/hand"
require "libs/menu"

$DELIM = "\r\n"

class Game < EventMachine::Connection
  attr_reader :running
  
  # Costruttore della classe.
  def initialize
    @screen = Screen.new([1024, 768], 
                         0, 
                         [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF])
    @screen.title = "Virtual Table"
    @events = Rubygame::EventQueue.new
    @events.enable_new_style_events    
    # Game data
    @picked = nil # oggetto preso col click e loccato, si assegna il nick
    @menu = nil # menu
    @accepted = false # true quando il server accetta l'entrata in gioco
    @running = true # se false il client esce
    # Send nick
    @nick = "user_#{rand 1000}"
    send_msg(Msg.dump(:type => "Nick", :args => @nick))
  rescue Exception => e
    p e
    exit!
  end
  
  # Connessione persa o uscita dal client.
  def unbind
    @running = false
    return
  end
  
  # Procedura che viene richiamata ciclicamente, loop del game.
  def tick
    env = Env.instance
    @events.each do |ev|
      # puts ev.inspect
      case ev
      when Rubygame::Events::MousePressed
        env.objects.reverse.each do |o|
          if o.collide?(*ev.pos)
            if (o.is_pickable? and (o.lock == nil or o.lock == @nick))
              # richiesta del pick
              send_msg(Msg.dump(:type => "Pick", 
                                :oid => o.oid, 
                                :args => [ev.button, ev.pos]))
            end
            break
          end
        end
      when Rubygame::Events::MouseReleased
        if @picked
          if (@menu and @menu.choice)
            @picked.send(@menu.choice.to_sym)
            send_msg(Msg.dump(:type => "Action", 
                              :oid => @picked.oid, 
                              :args => @menu.choice.to_sym))
            if @menu.choice.end_with?("card4all")
              # richiesta carte attiva
              send_msg(Msg.dump(:type => "GetValue"))
            end
          end
          @menu = nil # chiusura menu
          # rilascio dell'oggetto in pick, e quindi lockato
          send_msg(Msg.dump(:type => "UnLock", :oid => @picked.oid))
          @picked = nil
        end
      when Rubygame::Events::MouseMoved
        if @picked
          if ev.buttons[0] == :mouse_left
            # spostamento se l'oggetto e' in pick
            move = @picked.move(*ev.pos) # muove l'oggetto
            if move
              send_msg(Msg.dump(:type => "Move", 
                                :oid => @picked.oid, 
                                :args => move))
            end
          else
            @menu.select(ev) if @menu
          end
        end
      when Rubygame::Events::QuitRequested
        unbind
      else
        # puts ev.inspect
      end
    end
    if @accepted
      env.table.draw(@screen)
      env.objects.each { |o| o.draw(@screen) }
      @menu.draw(@screen) if @menu
      @screen.flip
    end
  end
  
  # Invia messaggi al server.
  def send_msg(data)
    data = "#{data}#{$DELIM}" unless data.end_with?($DELIM)
    send_data(data)
  end
  
  # Ricezione e gestione dei messaggi del server.
  def receive_data(data)
    env = Env.instance
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Object"
        if m.data.kind_of?(Table)
          env.add_table(m.data.init_graph)
        elsif m.data.kind_of?(Array)
          m.data.each do |o|
            env.add_object(o.init_graph)
          end
          env.add_hand(env.get_object(@nick))
        end
        @accepted = true # accettato dal server, si iniziare a disegnare
      when "Move"
        env.get_object(m.oid).set_pos(*m.args)
      when "Pick"
        @picked = env.get_object(m.oid)
        @picked.save_pick_pos(*m.args[1]) # salva il punto di click
        if m.args[0] == :mouse_left
          unless @picked.kind_of?(Hand)
            # preso l'oggetto in pick, va in primo piano no per hand
            env.to_front(@picked)
          end
        else
          @menu = Menu.new(m.args[1], @picked) # apre menu
        end
      when "Lock"
        o = env.get_object(m.oid)
        o.lock = m.args[1] # lock, nick di chi ha fatto pick
        if m.args[0] == :mouse_left
          # porta l'oggetto in pick di un altro in primo piano
          env.to_front(o)
        end
      when "UnLock"
        env.get_object(m.oid).lock = nil # toglie il lock
      when "Hand"
        env.add_first_object(m.data.init_graph) # arriva un player
      when "UnHand"
        env.del_object_by_id(m.oid) # va via un player
      when "Action"
        args = Array(m.args)
        env.get_object(m.oid).send(*args)
        if args[0].to_s.end_with?("card4all") # richiesta carte passiva
          send_msg(Msg.dump(:type => "GetValue"))
        end
      end
    end
  end
  
end


puts "\nVirtual Table Client"
print "Inserisci l'ip del server (0.0.0.0): "
$IP = $stdin.gets.chomp

EventMachine::run do
  emg = EventMachine::connect($IP != "" ? $IP : "0.0.0.0", 3333, Game)
  give_tick = proc do 
    emg.tick
    unless emg.running
      Rubygame.quit
      EventMachine::stop_event_loop
    end
    EventMachine.next_tick(give_tick)
    # sleep 0.08
  end
  trap("INT") do
    # Rubygame.quit
    EventMachine::stop_event_loop
  end
  give_tick.call
end
