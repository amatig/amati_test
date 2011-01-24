#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"

module Server
  @@clients ||= {}
  @@waiting ||= {}
  
  def send_msg(msg)
    send_data("#{msg}\r\n")
  end
  
  def post_init
    @@table ||= Table1.new
    @@objects ||= [Deck1.new(54), Card.new("deck1", "c", 10)]
    
    #if @@clients.empty?
      send_msg(Msg.dump(:type => "Object", :data => @@table))
      send_msg(Msg.dump(:type => "Object", :data => @@objects))
      @@clients.merge!({self.object_id => self})
    #else
    #  @@waiting.merge!({self.object_id => self})      
    #end
  rescue Exception => e
    p e
    exit!
  end
  
  def unbind
    @@clients.delete(self.object_id)
  end
  
  def receive_data(data)
    #puts Thread.current
    data.split("\r\n").each do |str|
      m = Msg.load(str)
      case m.type
      when "Nick"
        @name = m.data
      when "Move"
        @@objects.each do |o|
          if o.oid == m.oid
            o.set_pos(*m.args)
            resend_msg(data)
            break
          end
        end
      end
    end
  end
  
  def resend_msg(data)
    @@clients.values.each do |cl|
      if cl.object_id != self.object_id
        cl.send_data(data)
      end
    end
  end
  
end


EventMachine::run do
  EventMachine::start_server("0.0.0.0", 3333, Server)
  trap("INT") { EventMachine::stop_event_loop }
  puts "Server is running..."
end
