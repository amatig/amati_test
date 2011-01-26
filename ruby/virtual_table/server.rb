#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"

$DELIM = "\r\n"

class Server
  attr_accessor :connections, :table, :objects, :hash_objects
  
  # Costruttore della classe.
  def initialize
    # Clients data
    @connections = {} # hash di tutti client connessi
    
    # Game data
    @table = Table1.new # tavolo
    @objects = [Deck1.new(54), Card.new("deck1", "c", 10)] # lista oggetti sul tavolo
    @hash_objects = {} # per accedere agli oggetti + velocemente
    @objects.each do |o|
      @hash_objects[o.oid] = o # assignazione all'hash
    end
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
        @nick = m.data # nick del client
        # invio dei dati del gioco tavolo, oggetti
        send_msg(Msg.dump(:type => "Object", :data => server.table))
        send_msg(Msg.dump(:type => "Object", :data => server.objects))
      when "Move"
        server.hash_objects[m.oid].set_pos(*m.args) # salva il movimento
        resend_without_me(data) # rinvia a tutti gli altri il movimento dell'oggetto
      when "Pick"
        o = server.hash_objects[m.oid]
        # vede se un oggetto e' disponibile
        if (o.is_pickable? and (o.lock == nil or o.lock == @nick))
          # preso l'oggeto lo si porta in primo piano
          server.objects.delete(o)
          server.objects.push(o)
          o.lock = @nick # lock oggetto col nick di chi l'ha cliccato
          send_msg(data) # rinvio del pick a chi l'ha cliccato
          # rinvio a tutti gli altri del lock dell'oggetto
          resend_without_me(Msg.dump(:type => "Lock", :oid => m.oid, :data => @nick))
        end
      when "UnLock"
        # Unlock dell'oggetto in pick e rinvio a tutti
        # tranne a chi lo muoveva, perche' per lui non lockato
        server.hash_objects[m.oid].lock = nil # unlock
        resend_without_me(data)
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
