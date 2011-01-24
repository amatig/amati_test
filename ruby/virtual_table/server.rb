#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"

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
    data.split("\r\n").each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @nick = m.data
        send_me(Msg.dump(:type => "Object", :data => server.table))
        send_me(Msg.dump(:type => "Object", :data => server.objects))
      when "Move"
        server.hash_objects[m.oid].set_pos(*m.args)
        resend_all(data)
      when "Pick"
        temp = server.objects.delete(server.hash_objects[m.oid])
        server.objects.push(temp)
        send_data(data)
        resend_without_me(Msg.dump(:type => "Lock", :oid => m.oid))
      end
    end
  end
  
  def send_me(msg)
    send_data("#{msg}\r\n")
  end
  
  def resend_all(data)
    server.connections.values.each do |cl|
      cl.send_data(data)
    end
  end
  
  def resend_without_me(data)
    server.connections.values.each do |cl|
      if cl.object_id != self.object_id
        cl.send_data(data)
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
