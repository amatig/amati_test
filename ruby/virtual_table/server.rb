#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"
require "libs/hand"

$DELIM = "\r\n"

class Server
  attr_accessor :connections, :table, :objects, :hash_objects
  
  # Costruttore della classe.
  def initialize
    # Clients data
    @connections = {} # hash di tutti client connessi    
    
    # Game data all'avvio del server
    @table = Table.new # tavolo
    @objects = [] # lista oggetti sul tavolo
    @hash_objects = {} # per accedere agli oggetti + velocemente
    deck = DeckPoker.new(54)
    @objects << deck
    @hash_objects[deck.oid] = deck
    deck.set_data_refs(@objects, @hash_objects)
  end
  
  # Avvio della ricezione di connessioni da parte di client.
  def start
    @signature = EventMachine.start_server('0.0.0.0', 3333, Connection) do |con|
      con.server = self # istanza di server per avere i dati del gioco
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
    # rimuove la hand da tutti e dal server
    resend_all(Msg.dump(:type => "UnHand", :oid => @hand.oid))
    server.objects.delete(@hand)
    server.hash_objects.delete(@hand.oid)
    # unlock di tutti gli oggetti del client
    server.objects.each do |o|
      o.lock = nil if (o.lock == @nick)
    end
    # rimuove il client dell'hash delle connessioni
    server.connections.delete(self.object_id)
  end
  
  # Ricezione e gestione dei messaggi del client.
  def receive_data(data)
    # puts Thread.current
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @nick = m.args # nick del client
        @hand = Hand.new(@nick) # hand del client
        server.objects.insert(0, @hand)
        server.hash_objects[@hand.oid] = @hand
        # resend_all(Msg.dump(:type => "Hand", :data => @hand))
        # invio dei dati del gioco tavolo, oggetti
        send_msg(Msg.dump(:type => "Object", :data => server.table))
        send_msg(Msg.dump(:type => "Object", :data => server.objects))
        # manda a tutti gli altri la hand
        resend_without_me(Msg.dump(:type => "Hand", :data => @hand))
      when "Move"
        server.hash_objects[m.oid].set_pos(*m.args) # salva il movimento
        resend_without_me(str) # rinvia a tutti gli altri il movimento dell'oggetto
      when "Pick"
        o = server.hash_objects[m.oid]
        # vede se un oggetto e' disponibile
        if (o.is_pickable? and (o.lock == nil or o.lock == @nick))
          if (m.args[0] == :mouse_left and not o.kind_of?(Hand))
            # preso l'oggeto lo si porta in primo piano non per hand
            server.objects.delete(o)
            server.objects.push(o)
          end
          send_msg(str) # rinvio del pick a chi l'ha cliccato
          unless o.kind_of?(Hand) # e' sempre loggata hand
            o.lock = @nick # lock oggetto col nick di chi l'ha cliccato
            # rinvio a tutti gli altri del lock dell'oggetto
            resend_without_me(Msg.dump(:type => "Lock", :oid => m.oid, :args => [m.args[0], @nick]))
          end
        end
      when "UnLock"
        o = server.hash_objects[m.oid]
        unless o.kind_of?(Hand) # non unlock hand
          # Unlock dell'oggetto in pick e rinvio a tutti
          # tranne a chi lo muoveva, perche' per lui non lockato
          o.lock = nil # unlock
          resend_without_me(str)
        end
      when "Action"
        # azione su un oggetto
        new_data = server.hash_objects[m.oid].send(m.args)
        unless m.args == :action_shuffle
          resend_without_me(str)
        else
          resend_all(Msg.dump(:type => "Action", :oid => m.oid, :args => m.args, :data => new_data))
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
