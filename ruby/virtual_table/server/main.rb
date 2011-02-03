#!/usr/bin/ruby

require "rubygems"
require "eventmachine"
require "rubygame/rect"
require "singleton"

require "libs/env"
require "libs/msg"
require "libs/vobject"
require "libs/table"
require "libs/deck"
require "libs/secret_deck"
require "libs/card"
require "libs/hand"

$DELIM = "\r\n"

class Server
  
  # Costruttore della classe.
  def initialize
    # Game data all'avvio del server
    env = Env.instance
    env.add_table(Table.new) # tavolo
    env.add_object(DeckPoker.new) # deck
  end
  
  # Avvio della ricezione di connessioni da parte di client.
  def start
    EventMachine.start_server('0.0.0.0', 3333, Connection) do |conn|
      # aggiunge il nuovo client all'hash
      Env.instance.add_client(conn)
    end
  end
  
end

class Connection < EventMachine::Connection
  
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
    hand = env.get_hand(self.object_id)
    # rimuove la hand da tutti e dal server
    resend_all(Msg.dump(:type => "UnHand", :oid => hand.oid))
    env.del_hand(hand)
    # unlock di tutti gli oggetti del client
    env.objects.each do |o|
      o.lock = nil if (o.lock == @nick)
    end
    # rimuove il client dell'hash delle connessioni
    env.del_client(self)
  end
  
  # Ricezione e gestione dei messaggi del client.
  def receive_data(data)
    env = Env.instance
    # puts Thread.current
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @nick = m.args  # nick del client
        # mette in hash la hand e in object
        hand = env.add_hand(self.object_id, Hand.new(@nick))
        # invio dei dati del gioco tavolo, oggetti
        send_msg(Msg.dump(:type => "Object", :data => env.table))
        send_msg(Msg.dump(:type => "Object", :data => env.objects))
        # manda a tutti gli altri la hand
        resend_without_me(Msg.dump(:type => "Hand", :data => hand))
      when "Move"
        o = env.get_object(m.oid)
        if o.lock == @nick
          o.set_pos(*m.args) # salva il movimento
          resend_without_me(str) # rinvia agli altri move dell'oggetto
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
            resend_without_me(Msg.dump(:type => "Lock", 
                                       :oid => m.oid, 
                                       :args => [m.args[0], @nick]))
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
          hands = env.hands.values
          cards.push(o)
        elsif o.kind_of?(Hand)
          hands.push(o)
          cards = env.objects.select { |c| c.kind_of?(Card) }
        end
        hands.each do |h|
          cards.each do |c|
            if h.fixed_collide?(c)
              ret = SecretDeck.instance.get_value(c.oid)
              client_id = env.get_hand_key(h)
              send_msg_to(client_id, Msg.dump(:type => "Action", 
                                              :oid => c.oid, 
                                              :args => [:set_value, ret]))
            end
          end
        end
      when "GetValue"
        hand = env.get_hand(self.object_id)
        cards = env.objects.select { |c| c.kind_of?(Card) }
        cards.each do |c|
          if hand.fixed_collide?(c)
            ret = SecretDeck.instance.get_value(c.oid)
            send_msg(Msg.dump(:type => "Action", 
                              :oid => c.oid, 
                              :args => [:set_value, ret]))
          end
        end
      when "Action"
        o = env.get_object(m.oid)
        if o.lock == @nick
          if (m.args == :action_shuffle or 
              m.args == :action_turn or 
              m.args.to_s.start_with?("action_create"))
            ret = o.send(m.args) # azione su un oggetto
            resend_all(Msg.dump(:type => "Action", 
                                :oid => m.oid, 
                                :args => [m.args, ret]))
          elsif m.args == :action_take
            hand = env.get_hand(self.object_id)
            pos = [hand.x - 80, hand.y + 32]
            cards = env.objects.select do |c| 
              c != o and c.kind_of?(Card) and c.fixed_collide?(o)
            end
            cards.push(o)
            cards.each do |c|
              c.send(:action_turnoff) # azione su un oggetto
              resend_all(Msg.dump(:type => "Action", 
                                  :oid => c.oid, 
                                  :args => :action_turnoff))
              c.send(m.args, pos) # azione su un oggetto
              resend_all(Msg.dump(:type => "Action", 
                                  :oid => c.oid, 
                                  :args => [m.args, pos]))
            end
          else
            o.send(m.args) # azione su un oggetto
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
  
  # Invia un messaggio ad un client preciso.
  def send_msg_to(client_id, data)
    Env.instance.get_client(client_id).send_msg(data)
  end
  
  # Invia un messaggio a tutti i client.
  def resend_all(data)
    Env.instance.clients.values.each do |cl|
      cl.send_msg(data)
    end
  end
  
  # Invia un messaggio a tutti i client tranne l'attuale.
  def resend_without_me(data)
    Env.instance.clients.values.each do |cl|
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
