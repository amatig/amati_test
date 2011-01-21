require "libs/vobject"

class Table < VObject
  
  def initialize(table)
    @images = Surface.load("./images/#{table}.png")
    @rect = @images.make_rect
    #@is_movable = false
  end
  
end
