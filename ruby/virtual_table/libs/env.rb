require "singleton"

class Env
  include Singleton
  attr_accessor :nick, :table, :objects, :hash_objects
  
  def instance
  end
  
end

