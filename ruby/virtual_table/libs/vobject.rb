class VObject
  
  def initialize
    @images = nil
    @rect = nil
    @is_movable = true
  end
  
  def collide?(x, y)
    return @rect.collide_point?(x, y)
  end
  
  def move(x, y)
    if @is_movable
      @rect.move!(x - @rect.centerx, y - @rect.centery)
    end
  end
  
  def draw(screen)
    @images.blit(screen, @rect)
  end
  
end
