require "libs/vobject"

class Hand < VObject
  
  def initialize(nick)
    super()
    @lock = nick
  end
  
  def init
    @image = Surface.load("./images/hand1.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
  end
  
end
