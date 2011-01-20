require "rubygems"
require "eventmachine"

module Server
  @@clients_list ||= {}
  
  def post_init
    @identifier = self.object_id
    @@clients_list.merge!({@identifier => self})
    
    send_data "benvenuto"
  end
  
  def unbind
    @@clients_list.delete(@identifier)
  end
  
  def receive_data(data)
    puts Thread.current
    if @name == nil then
      @name ||= data.strip
    else
      @@clients_list.values.each do |client|
        client.send_data "#{@name}: #{data}"
      end
    end
  end
  
end


EventMachine::run do
  EventMachine::start_server("0.0.0.0", 8081, Server)
  trap("INT") { EventMachine::stop_event_loop }
  puts "Running chat server on 8081"
end
