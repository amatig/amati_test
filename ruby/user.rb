require "thread"
require "database.rb"

class User
  
  def User.get(nick)
    data = Database.instance.get(["id", "nick"], 
                                 "users", 
                                 "nick='#{nick}'")
    return (data.empty?) ? nil : User.new(data)
  end
  
  def initialize(data)
    @db = Database.instance
    
    @nick = data[0]
    @stand_up = true
    @place = @db.get(["id", "name", "descr", "attrs"], 
                     "places", 
                     "id=1")
    @near_place = @db.read(["places.id", "name", "descr", "attrs"], 
                           "links,places", 
                           "place=#{@place[0]} and places.id=near_place")
    
    @mutex_place = Mutex.new
    @mutex_attrs = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def move(id)
    @mutex_place.synchronize do
      @place = @db.get(["id", "name", "descr", "attrs"], 
                       "places", 
                       "id=#{id}")
      @near_place = @db.read(["places.id", "name", "descr", "attrs"], 
                             "links,places", 
                             "place=#{@place[0]} and places.id=near_place")
    end
  end
  
  def place()
    @mutex_place.synchronize do
      return @place
    end
  end
  
  def near_place()
    @mutex_place.synchronize do
      return @near_place
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
