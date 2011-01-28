require "libs/vobject"

class Table < VObject
  
  def initialize
    super()
    @name = "table1"
    @movable = false
    @pickable = false
  end
  
  def init
    @image = Surface.load("./images/#{@name}.jpg")
    @rect = @image.make_rect
    return self
  end
  
  def change_bg(name)
    @name = name
    @image = Surface.load("./images/#{@name}.jpg")
  end
  
end
