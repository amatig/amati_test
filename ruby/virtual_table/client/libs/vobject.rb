class VObject
  attr_accessor :x, :y, :picked
  
  def initialize
    @images = nil
    @rect = nil
    @is_movable = true
    @picked = false
  end
  
  def collide?(x, y)
    @rect.collide_point?(x, y)
  end
  
  def move(x, y)
    if @picked
      @rect.move!(x - @rect.x, y - @rect.y)
    end
  end
  
  def draw(screen)
    @images.blit(screen, @rect)
  end
  
end
