require "libs/card"

class Deck1
  attr_accessor :x, :y
  
  def initialize
    @images = Surface.load("./images/deck1/back1.png")
    @x = 0
    @y = 0
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
  
  def draw(screen)
    @images.blit(screen, [@x, @y])
  end
  
end
