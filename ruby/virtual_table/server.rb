#!/usr/bin/ruby

require "rubygems"
require "eventmachine"
require "rubygame/rect"

require "libs/env"
require "libs/msg"
require "libs/table"
require "libs/deck"
require "libs/hand"

$DELIM = "\r\n"

class Server
  attr_accessor :connections
  
  # Costruttore della classe.
  def initialize
    # Clients data
    @connections = {} # hash di tutti client connessi
    
    # Game data all'avvio del server
    env = Env.instance
    env.table = Table.new # tavolo
    env.add_object(DeckPoker.new(54)) # deck
  end
  
  # Avvio della ricezione di connessioni da parte di client.
  def start
    @signature = EventMachine.start_server('0.0.0.0', 3333, Connection) do |con|
      con.server = self
      @connections[con.object_id] = con # aggiunge il nuovo client all'hash
    end
  end
  
end

class Connection < EventMachine::Connection
  attr_accessor :server
  
  # Init della connessione del client.
  def post_init
    # ...
  rescue Exception => e
    p e
    exit!
  end
  
  # Connessione persa o uscita del client.
  def unbind
    env = Env.instance
    # rimuove la hand da tutti e dal server
    resend_all(Msg.dump(:type => "UnHand", :oid => env.hands[self.object_id].oid))
    env.del_object(env.hands[self.object_id])
    env.hands.delete(self.object_id)
    # unlock di tutti gli oggetti del client
    env.objects.each do |o|
      o.lock = nil if (o.lock == @nick)
    end
    # rimuove il client dell'hash delle connessioni
    server.connections.delete(self.object_id)
  end
  
  # Ricezione e gestione dei messaggi del client.
  def receive_data(data)
    env = Env.instance
    # puts Thread.current
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @nick = m.args # nick del client
        env.hands[self.object_id] = env.add_first_object(Hand.new(@nick)) # hand
        # invio dei dati del gioco tavolo, oggetti
        send_msg(Msg.dump(:type => "Object", :data => env.table))
        send_msg(Msg.dump(:type => "Object", :data => env.objects))
        # manda a tutti gli altri la hand
        resend_without_me(Msg.dump(:type => "Hand", :data => env.hands[self.object_id]))
      when "Move"
        o = env.get_object(m.oid)
        if o.lock == @nick
          o.set_pos(*m.args) # salva il movimento
          resend_without_me(str) # rinvia a tutti gli altri il movimento dell'oggetto
        end
      when "Pick"
        o = env.get_object(m.oid)
        # vede se un oggetto e' disponibile
        if (o.is_pickable? and (o.lock == nil or o.lock == @nick))
          if (m.args[0] == :mouse_left and not o.kind_of?(Hand))
            # preso l'oggeto lo si porta in primo piano non per hand
            env.to_front(o)
          end
          send_msg(str) # rinvio del pick a chi l'ha cliccato
          unless o.kind_of?(Hand) # e' sempre loggata hand
            o.lock = @nick # lock oggetto col nick di chi l'ha cliccato
            # rinvio a tutti gli altri del lock dell'oggetto
            resend_without_me(Msg.dump(:type => "Lock", :oid => m.oid, :args => [m.args[0], @nick]))
          end
        end
      when "UnLock"
        o = env.get_object(m.oid)
        if (not o.kind_of?(Hand) and o.lock == @nick) # non unlock hand
          # Unlock dell'oggetto in pick e rinvio a tutti
          # tranne a chi lo muoveva, perche' per lui non lockato
          o.lock = nil # unlock
          resend_without_me(str)
        end
        hands = [] # lista temporanea di hands
        cards = [] # lista temporanea di cards
        if o.kind_of?(Card)
          hands = env.objects.select { |h| h.kind_of?(Hand) }
          cards.push(o)
        elsif o.kind_of?(Hand)
          hands.push(o)
          cards = env.objects.select { |c| c.kind_of?(Card) }
        end
        hands.each do |h|
          rhd = Rubygame::Rect.new(h.x, h.y, 315, 175)
          cards.each do |c|
            rc = Rubygame::Rect.new(c.x, c.y, 70, 109)
            if rc.collide_rect?(rhd)
              ret = SecretDeck.instance.get_value(c.oid)
              server.connections[env.hands.index(h)].send_msg(Msg.dump(:type => "Action", 
                                                                       :oid => c.oid, 
                                                                       :args => :set_value, 
                                                                       :data => ret))
            end
          end
        end
      when "Action"
        o = env.get_object(m.oid)
        if o.lock == @nick
          ret = o.send(*m.args) # azione su un oggetto
          if (m.args == :action_shuffle or m.args == :action_turn or m.args == :action_create)
            resend_all(Msg.dump(:type => "Action", :oid => m.oid, :args => m.args, :data => ret))
          else
            resend_without_me(str)
          end
        end
      end
    end
  end
  
  # Invia un messaggio al client.
  def send_msg(data)
    data = "#{data}#{$DELIM}" unless data.end_with?($DELIM)
    send_data(data)
  end
  
  # Invia un messaggio a tutti i client.
  def resend_all(data)
    server.connections.values.each do |cl|
      cl.send_msg(data)
    end
  end
  
  # Invia un messaggio a tutti i client tranne l'attuale.
  def resend_without_me(data)
    server.connections.values.each do |cl|
      if cl.object_id != self.object_id
        cl.send_msg(data)
      end
    end
  end
  
end


EventMachine::run do
  s = Server.new
  s.start
  trap("INT") { EventMachine::stop_event_loop }
  puts "Server is running..."
end
