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
    
    @id = self.object_id
    if @@clients.empty?
      send_msg(Msg.dump(:type => "Object", :data => @@table))
      send_msg(Msg.dump(:type => "Object", :data => @@objects))
      @@clients.merge!({@id => self})
    else
      @@waiting.merge!({@id => self})      
    end
  rescue Exception => e
    p e
    exit!
  end
  
  def unbind
    @@clients.delete(@id)
  end
  
  def receive_data(data)
    #puts Thread.current
    if @name == nil then
      @name ||= data.strip
    else
      # @@clients.values.each do |cl|
        #cl.send_data "#{@name}: #{data}"
        puts "#{@name}: #{data}"
      #end
    end
  end
  
end


EventMachine::run do
  EventMachine::start_server("0.0.0.0", 3333, Server)
  trap("INT") { EventMachine::stop_event_loop }
  puts "Server is running..."
end
