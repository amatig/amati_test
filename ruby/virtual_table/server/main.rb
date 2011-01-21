#!/usr/bin/ruby

require "rubygems"
require "eventmachine"

module Server
  @@clients ||= {}
  
  def post_init
    @id = self.object_id
    @@clients.merge!({@id => self})
    
    send_data "benvenuto"
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
        cl.send_data "#{@name}: #{data}"
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
