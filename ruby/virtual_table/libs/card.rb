require "libs/vobject"

class Card < VObject
  attr_reader :deck, :seed, :num
  
  def initialize(deck, s, n)
    super()
    @oid = "#{deck}_#{s}_#{n}" # server un indice unico
    @deck = deck
    @seed = s
    @num = n
  end
  
  def init
    @image = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    @image_lock = Surface.load("./images/lock.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
end
