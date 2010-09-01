class User
    
  def initialize(data)
    @nick = data[0]
    @place = 1
    @stand_up = true 
  end
  
  def set_place(id)
    @place = id
  end
  
  def place()
    return @place
  end
  
  def up()
    return false if @stand_up
    @stand_up = true
    return true
  end
  
  def down()
    return false unless @stand_up
    @stand_up = false
    return true
  end
  
  def to_s()
    return @nick
  end
  
end
