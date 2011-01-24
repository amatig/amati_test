class VObject
  attr_reader :oid, :lock
  
  def initialize
    @oid = rand(1000000000)
    @images = nil
    @rect = nil
    @x = 0
    @y = 0
    @is_movable = true
    @lock = nil
  end
  
  def collide?(x, y)
    return @rect.collide_point?(x, y)
  end
  
  def get_pos
    return [@x, @y]
  end
  
  def set_pos(x, y)
    if @rect
      @rect.x = x
      @rect.y = y
    end
    @x = x
    @y = y
  end
  
  def move(x, y)
    if @is_movable
      @rect.move!(x - @rect.centerx, y - @rect.centery)
      @x = @rect.x
      @y = @rect.y
      return get_pos
    end
  end
  
  def draw(screen)
    @images.blit(screen, @rect)
  end
  
end
