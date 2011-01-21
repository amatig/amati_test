require "libs/vobject"
require "libs/card"

class Deck1 < VObject
  
  def initialize
    @images = Surface.load("./images/deck1/back1.png")
    @rect = @images.make_rect
    @cards = []
  end
  
  def load_40
    @cards = []
    ["c", "q", "f", "p"].each do |s|
      (1..10).each do |n|
        @cards << Card.new("deck1", s, n)
      end
    end
  end
  
  def load_52
    @cards = []
    ["c", "q", "f", "p"].each do |s|
      (1..13).each do |n|
        @cards << Card.new("deck1", s, n)
      end
    end
  end
  
  def load_54
    load_52
    @cards << Card.new("deck1", "r", 0)
    @cards << Card.new("deck1", "b", 0)
  end
  
  def size
    @cards.size
  end
  
end
