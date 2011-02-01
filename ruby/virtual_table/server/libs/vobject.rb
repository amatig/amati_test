class VObject
  attr_reader :oid, :x, :y
  attr_accessor :lock
  
  def initialize
    # indice univoco
    @oid = (0...10).collect { rand(10) }.join
    # coordinate oggetto
    @x = 0
    @y = 0
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
  
  def get_pos
    return [@x, @y]
  end
  
  def set_pos(x, y)
    @x = x
    @y = y
  end
  
end
