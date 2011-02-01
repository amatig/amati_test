require "libs/vobject"

class Hand < VObject
  
  def initialize(nick)
    super()
    @oid = nick
    @lock = nick
    @label = nil # label nick
    @x = rand(450) + 100
    @y = rand(320) + 100
  end
  
  def init
    if defined?(TTF)
      TTF.setup
      font = TTF.new("./fonts/FreeSans.ttf", 20)
      @label = font.render_utf8(@lock, true, [255, 255, 255])
    end
    @image = Surface.load("./images/hand1.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def draw(screen)
    @image.blit(screen, @rect)
    @label.blit(screen, [@rect.x + 20, @rect.y + 10]) if @label
  end
  
end
