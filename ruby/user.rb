require "thread"
require "database.rb"

class User
  
  def User.get(user)
    data = Database.instance.get(["*"], "users", "nick='#{user}'")
    return (data.empty?) ? nil : User.new(data)
  end
  
  def initialize(data)
    @db = Database.instance
    
    @nick = data[0]
    @place = 1
    @stand_up = true
    
    @mutex_place = Mutex.new
    @mutex_attrs = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def set_place(id)
    @mutex_place.synchronize do
      @place = Integer(id)
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
  
  def stand_up?()
    @mutex_attrs.synchronize do
      return @stand_up
    end
  end
  
  def to_s()
    return @nick
  end
  
end
