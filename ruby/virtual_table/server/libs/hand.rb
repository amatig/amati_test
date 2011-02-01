class Hand < VObject
  
  def initialize(nick)
    super()
    @oid = nick
    @lock = nick
    @x = rand(450) + 100
    @y = rand(320) + 100
  end
  
end
