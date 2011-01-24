require "libs/vobject"

class Card < VObject
  attr_reader :seed, :number
  
  def initialize(deck, s, n)
    @deck = deck
    @seed = s
    @num = n
  end
  
  def init
    @images = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    @rect = @images.make_rect
  end
  
end
