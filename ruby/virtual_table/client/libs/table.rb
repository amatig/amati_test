class Table < VObject
  
  def initialize
    super()
    @name = "table1"
    @movable = false
    @pickable = false
    init_graph
  end
  
  def init_graph
    @image = Surface.load("./images/#{@name}.jpg")
    @rect = @image.make_rect
    return self
  end
  
  def change_bg(name)
    @name = name
    @image = Surface.load("./images/#{@name}.jpg")
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
  end
  
end
