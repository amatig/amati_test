#!/usr/bin/env ruby -w

require 'drb'

class Datas
  include DRbUndumped
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    return @name
  end
  
end

class Server
  attr :data
  
  def initialize(array)
    @data = array
  end
  
  def get(index)
    puts @data[index]
    return @data[index]
  end
  
end

d = [
  Datas.new("Amish Paradise"),
  Datas.new("Eat it")
]

DRb.start_service nil, Server.new(d)
puts DRb.uri

DRb.thread.join
