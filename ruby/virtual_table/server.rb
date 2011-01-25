#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"

$DELIM = "\r\n"

class Server
  attr_accessor :connections, :table, :objects, :hash_objects
  
  def initialize
    # Clients data
    @connections = {}
    # Game data
    @table = Table1.new
    @objects = [Deck1.new(54), Card.new("deck1", "c", 10)]
    @hash_objects = {}
    @objects.each do |o|
      @hash_objects[o.oid] = o
    end
  end
  
  def start
    @signature = EventMachine.start_server('0.0.0.0', 3333, Connection) do |con|
      con.server = self
      @connections[con.object_id] = con
    end
  end
  
end

class Connection < EventMachine::Connection
  attr_accessor :server
  
  def post_init
    # ...
  rescue Exception => e
    p e
    exit!
  end
  
  def unbind
    server.connections.delete(self.object_id)
  end
  
  def receive_data(data)
    # puts Thread.current
    data.split($DELIM).each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @nick = m.data
        send_msg(Msg.dump(:type => "Object", :data => server.table))
        send_msg(Msg.dump(:type => "Object", :data => server.objects))
      when "Move"
        server.hash_objects[m.oid].set_pos(*m.args)
        resend_all(data)
      when "Pick"
        unless server.hash_objects[m.oid].lock
          temp = server.objects.delete(server.hash_objects[m.oid])
          server.objects.push(temp)
          temp.lock = @nick
          send_msg(data)
          resend_without_me(Msg.dump(:type => "Lock", :oid => m.oid, :data => @nick))
        end
      when "UnLock"
        server.hash_objects[m.oid].lock = nil
        resend_without_me(data)
      end
    end
  end
  
  def send_msg(msg)
    msg = "#{msg}#{$DELIM}" unless msg =~ /#{$DELIM}$/
    send_data(msg)
  end
  
  def resend_all(data)
    server.connections.values.each do |cl|
      cl.send_msg(data)
    end
  end
  
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
