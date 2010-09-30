require "rubygems"
require "IRC"
require "StParseEvent"
require "socket"

class Master < IRC
  
  def initialize(nick, server, port, channels, options) 
    super(nick, server, port, nil, options)
    @bot = self
    # This makes us listen to STDIN. It's handy sometimes.
    IRCConnection.add_IO_socket(STDIN) do |sock| 
      StParseEvent.new(sock.readline.chomp)
    end
    # Callbakcs for the connection.
    IRCEvent.add_callback("endofmotd") do |event| 
      channels.each { |chan| @bot.add_channel(chan) }
    end
    IRCEvent.add_callback("nicknameinuse") { |event| @bot.ch_nick("RubyBot") }
    IRCEvent.add_callback("privmsg") { |event| parse(event) }
    StParseEvent.add_handler("command") { |event| parse(event) }
    IRCEvent.add_callback("join") do |event|
      if @autoops.include?(event.from)
        @bot.op(event.channel, event.from)
      end
    end
    IRCEvent.add_callback("mode") do |event|
      # Gotta Break up the mode events.
      switch = "add"
      i = 5
      event.mode.scan(/[\+-ovh]/) do |mode|
        case mode
        when "-"
          switch = "sub"
        when "+"
          switch = "add"
        when "o"
          target = event.stats[i]
          if (@autoops.include?(event.from) && 
              ! @autoops.include?(target) && switch == "add")
            @autoops.add(target)
            @autoops.write
          else (@autoops.include?(event.from) && 
                @autoops.include?(target) && switch == "sub")
            @autoops.remove(target)
            @autoops.write
          end
          i += 1
        else
          i += 1
        end
      end
    end
  end
  
  def parse(event)
    target = (event.channel == @nick) ? event.from : event.channel
    msg = event.message
    
    case msg
    when /^(ciao|salve)$/i
      send_message(target, "Hello")
    end
  end
  
end


# Main

if __FILE__ == $0
  begin
    botnick  = "GameMaster"
    server   = "127.0.0.1"
    port     = "6667"
    channels = ["\#hall"]
    options  = {} # {:use_ssl => 1}
    Master.new(botnick, server, port, channels, options).connect
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
  end
end
