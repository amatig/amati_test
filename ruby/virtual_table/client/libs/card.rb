require "libs/vobject"

class Card < VObject
  attr_reader :seed, :number
  
  def initialize(deck, s, n)
    @images = Surface.load("./images/#{deck}/#{s}#{n}.png")
    @rect = @images.make_rect
    @seed = s
    @number = n
  end
  
end
