require "libs/vobject"

class Table < VObject
  
  def initialize(name)
    super()
    @name = name
    @movable = false
    @pickable = false
  end
  
  def init
    @image = Surface.load("./images/#{@name}.jpg")
    @rect = @image.make_rect
    return self
  end
  
end

class Table1 < Table
  
  def initialize
    super("table1")
  end
  
end
