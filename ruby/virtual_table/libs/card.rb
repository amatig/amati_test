require "libs/vobject"

class Card < VObject
  attr_reader :seed, :num
  
  def initialize(deck, s, n)
    super()
    @deck = deck
    @seed = s
    @num = n
  end
  
  def init
    @images = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    @rect = @images.make_rect
    set_pos(@x, @y)
    return self
  end
  
end
