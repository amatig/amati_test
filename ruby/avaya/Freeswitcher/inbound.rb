#!/usr/bin/ruby

require 'rubygems'
require 'fsr'
require 'fsr/listener/inbound'
#require 'fsr/command_socket'
#require "fsr/app/bridge"
#require "fsr/cmd/originate"

$hostname = "testpbx.fastdatatel.net"

class IesDemo < FSR::Listener::Inbound
  
  def initialize(*args)
    super(*args)
    @flag = false
  end
  
  def call(ext1, ext2)
    msg =  "originate"
    msg += " sofia/#{$hostname}/#{ext1}@#{$hostname}"
    msg += " &bridge(sofia/#{$hostname}/#{ext2}@#{$hostname})"
    api(msg)
  end
  
  def fax(ext, filename)
    msg =  "originate"
    msg += " sofia/#{$hostname}/#{ext}@#{$hostname}"
    msg += " &txfax(#{filename})"
    api(msg)
  end
  
  def on_event(event)
    # pp event
    pp event.headers
    if not @flag and event.headers.key?(:reply_text) and event.headers[:reply_text] == "+OK accepted"
      subscribe_to_event(:ALL)
      # call(200, 201)"
      fax(200, "/tmp/fax_4092747773614670738.tiff")
      @flag = true
    end
  end
  
end


if __FILE__ == $0
  begin
    FSR.start_ies!(IesDemo, :host => "192.168.69.1", :port => 8021, :auth => "ClueCon")
    
    # test command
    
    #socket = FSR::CommandSocket.new(:server => "192.168.69.1", :port => 8021, :auth => "ClueCon")
    #socket.originate(:target => "sofia/#{$hostname}/#{$ext1}@#{$hostname}",
    #                 :endpoint => FSR::App::Bridge.new("sofia/#{$hostname}/#{$ext2}@#{$hostname}")).run
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
  end
end
