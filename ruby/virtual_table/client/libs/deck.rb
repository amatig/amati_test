require "libs/vobject"
require "libs/card"

class Deck < VObject
  
  def initialize(name)
    @name = name
    @cards = []
  end
  
  def init
    @images = Surface.load("./images/#{@name}/back1.png")
    @rect = @images.make_rect
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
    return @cards.size
  end
  
end

class Deck1 < Deck
  
  def initialize
    super("deck1")
  end
  
end
