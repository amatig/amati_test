require "thread"
require "database.rb"

class User
  
  def User.get(nick)
    data = Database.instance.get(["id", "nick", "place"], 
                                 "users", 
                                 "nick='#{nick}'")
    return (data.empty?) ? nil : User.new(data)
  end
  
  def initialize(data)
    @db = Database.instance # singleton
    
    @mutex_time = Mutex.new    
    @mutex_place = Mutex.new
    @mutex_attrs = Mutex.new
    Thread.abort_on_exception = true
    
    # init dati utente
    @nick = data[1]
    @stand_up = true    
    move(data[2])
    
    @timestamp = Time.now.to_i
  end
  
  def save()
    @mutex_attrs.synchronize do
      @db.update({"place"=>Integer(@place[0])}, 
                 "users", 
                 "nick='#{@nick}'")
    end
  end
  
  def update_timestamp()
    @mutex_time.synchronize { @timestamp = Time.now.to_i }
  end
  
  def timestamp()
    @mutex_time.synchronize { return @timestamp }
  end
  
  def move(place_id)
    @mutex_place.synchronize do
      @place = @db.get(["id", "name", "descr", "attrs"], 
                       "places", 
                       "id=#{place_id}")
      @near_place = @db.read(["places.id", "name", "descr", "attrs"], 
                             "links,places", 
                             "place=#{@place[0]} and places.id=near_place")
    end
  end
  
  def place()
    @mutex_place.synchronize { return @place }
  end
  
  def near_place()
    @mutex_place.synchronize { return @near_place }
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
    @mutex_attrs.synchronize { return @stand_up }
  end
  
  def to_s()
    return @nick
  end
  
end
