class Hand < VObject
  
  def initialize(nick)
    super()
    @oid = nick
    @lock = nick
    @x = rand(450) + 100
    @y = rand(320) + 100
  end
  
  def fixed_collide?(card)
    rhd = Rubygame::Rect.new(@x, @y, 315, 175) # fissi
    rc = Rubygame::Rect.new(card.x, card.y, 70, 109) # fissi
    return rhd.collide_rect?(rc)
  end
  
end
