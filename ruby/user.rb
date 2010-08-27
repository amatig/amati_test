class User
  
  def initialize(nick)
    @nick = nick
    @place = 1
    @stand_up = true 
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
