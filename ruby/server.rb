#!/usr/bin/env ruby -w
require 'drb'

class User
  include DRbUndumped
  
  def initialize(name)
    @name = name
  end
  
  def to_s
    return @name
  end
  
end

class Server
  attr :user_list
  
  def initialize()
    @user_list = []
    @user_list << User.new("Amish Paradise")
    @user_list << User.new("Eat it")
  end
  
  def get(index)
    puts @user_list[index]
    return @user_list[index]
  end
  
end

DRb.start_service nil, Server.new
puts DRb.uri
DRb.thread.join
