class VObject
  attr_reader :oid
  attr_accessor :lock
  
  def initialize
    # indice univoco
    @oid = rand(1000000000)
    # dati della grafica
    @image = nil
    @image_lock = nil
    @rect = nil
    # coordinate oggetto
    @x = @px = 0 # x e punto x di pick sulla carta
    @y = @py = 0 # y e punto y di pick sulla carta
    # dati vari
    @movable = true
    @pickable = true
    @lock = nil
  end
  
  def is_movable?
    return @movable
  end
  
  def is_pickable?
    return @pickable
  end
  
  def collide?(x, y)
    return @rect.collide_point?(x, y)
  end
  
  def save_pick_pos(x, y)
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
    if is_movable?
      temp = @rect.move(x - @rect.x - @px, y - @rect.y - @py)
      return [temp.x, temp.y]
    end
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
