#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

require "libs/msg"
require "libs/table"
require "libs/deck"

module Server
  @@clients ||= {}
  @@waiting ||= {}
  @@table = nil
  @@objects ||= []
  
  def post_init
    @id = self.object_id
    if @@clients.empty?
      @@table = Table1.new
      send_data(Msg.dump(:type => "init", :data => @@table) + "\r\n")
      @@objects = [Deck1.new]
      send_data(Msg.dump(:type => "init", :data => @@objects) + "\r\n")
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
      @@clients.values.each do |cl|
        #cl.send_data "#{@name}: #{data}"
        puts data
      end
    end
  end
  
end


EventMachine::run do
  EventMachine::start_server("0.0.0.0", 3333, Server)
  trap("INT") { EventMachine::stop_event_loop }
  puts "Server is running..."
end
