class VObject
  attr_reader :oid
  attr_accessor :lock
  
  def initialize
    @oid = rand(1000000000)
    @image = nil
    @image_lock = nil
    @rect = nil
    @x = @px = 0
    @y = @py = 0
    @is_movable = true
    @lock = nil
  end
  
  def collide?(x, y)
    return @rect.collide_point?(x, y)
  end
  
  def pick_pos(x, y)
    @px = x - @rect.x
    @py = y - @rect.y
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
      temp = @rect.move(x - @rect.x - @px, y - @rect.y - @py)
      return [temp.x, temp.y]
    end
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
