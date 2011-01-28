#!/usr/bin/ruby

require "rubygems"
require "rubygame"
require "eventmachine"

include Rubygame

require "libs/msg"
require "libs/table"
require "libs/deck"
require "libs/menu"
require "libs/hand"

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
    @table = nil # tavolo
    @objects = [] # lista degli oggetti sul tavolo
    @hash_objects = {} # per accedere agli oggetti + velocemente
    @menu = nil # menu
    
    @picked = nil # oggetto preso col click e loccato, si assegna il nick
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
    @events.each do |ev|
      # puts ev.inspect
      case ev
      when Rubygame::Events::MousePressed
        @objects.reverse.each do |o|
          if o.collide?(*ev.pos)
            if (o.is_pickable? and (o.lock == nil or o.lock == @nick))
              # richiesta del pick
              send_msg(Msg.dump(:type => "Pick", :oid => o.oid, :args => [ev.button, ev.pos]))
            end
            break
          end
        end
      when Rubygame::Events::MouseReleased
        if @picked
          if (@menu and @menu.choice)
            @picked.send(@menu.choice.to_sym)
            send_msg(Msg.dump(:type => "Action", :oid => @picked.oid, :args => @menu.choice.to_sym))
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
              send_msg(Msg.dump(:type => "Move", :oid => @picked.oid, :args => move))
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
      @table.draw(@screen)
      @objects.each { |o| o.draw(@screen) }
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
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Object"
        if m.data.kind_of?(Table)
          @table = m.data.init # caricamento dell'immagine
        elsif m.data.kind_of?(Array)
          @objects = m.data # assegna l'array degli oggetti
          @objects.each do |o|
            o.init # caricament dell'immagine
            @hash_objects[o.oid] = o # assegnazione all'hash
            if (o.kind_of?(Deck))
              o.set_data_refs(@objects, @hash_objects, @hash_objects[@nick])
            elsif (o.kind_of?(Card))
              o.set_hand_refs(@hash_objects[@nick]) # mette mio hand
            end
          end
        end
        @accepted = true # accettato dal server, si iniziare a disegnare
      when "Move"
        @hash_objects[m.oid].set_pos(*m.args)
      when "Pick"
        @picked = @hash_objects[m.oid]
        @picked.save_pick_pos(*m.args[1]) # salva il punto di click
        if m.args[0] == :mouse_left
          unless @picked.kind_of?(Hand)
            # preso l'oggetto in pick, va in primo piano no per hand
            @objects.delete(@picked)
            @objects.push(@picked)
          end
        else
          @menu = Menu.new(m.args[1], @picked) # apre menu
        end
      when "Lock"
        o = @hash_objects[m.oid]
        o.lock = m.args[1] # lock, nick di chi ha fatto pick
        if m.args[0] == :mouse_left
          # porta l'oggetto in pick di un altro in primo piano
          @objects.delete(o)
          @objects.push(o)
        end
      when "UnLock"
        @hash_objects[m.oid].lock = nil # toglie il lock
      when "Hand"
        m.data.init
        @objects.insert(0, m.data)
        @hash_objects[m.data.oid] = m.data
      when "UnHand"
        o = @hash_objects[m.oid]
        @objects.delete(o)
        @hash_objects.delete(o.oid)
      when "Action"
        args = Array(m.args)
        args << m.data if m.data
        @hash_objects[m.oid].send(*args)
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
  end
  trap("INT") do
    # Rubygame.quit
    EventMachine::stop_event_loop
  end
  give_tick.call
end
