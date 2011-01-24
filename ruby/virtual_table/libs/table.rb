require "libs/vobject"

class Table < VObject
  
  def initialize(name)
    super()
    @name = name
    @is_movable = false
  end
  
  def init
    @images = Surface.load("./images/#{@name}.png")
    @rect = @images.make_rect
  end
  
end

class Table1 < Table
  
  def initialize
    super("table1")
  end
  
end
