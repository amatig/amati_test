require "thread"

class User
  
  def initialize(data)
    @nick = data[0]
    @place = 1
    
    @stand_up = true
    
    @mutex_place = Mutex.new
    @mutex_attrs = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def set_place(id)
    @mutex_place.synchronize do
      @place = id
    end
  end
  
  def place()
    @mutex_place.synchronize do
      return @place
    end
  end
  
  def up()
    @mutex_attrs.synchronize do    
      return false if @stand_up
      @stand_up = true
      return true
    end
  end
  
  def down()
    @mutex_attrs.synchronize do    
      return false unless @stand_up
      @stand_up = false
      return true
    end
  end
  
  def to_s()
    return @nick
  end
  
end
