class VObject
  attr_reader :oid, :x, :y
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
    if collide?(x, y)
      @px = x - @rect.x
      @py = y - @rect.y
    end
  end
  
  def get_pos
    return [@x, @y]
  end
  
  def set_pos(x, y)
    @rect.topleft = [x, y] if @rect
    @x = x
    @y = y
  end
  
  def move(x, y)
    if is_movable?
      temp = @rect.move!(x - @rect.x - @px, y - @rect.y - @py)
      @x = temp.x
      @y = temp.y
      return get_pos
    end
  end
  
  def menu_actions
    return []
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
