require "libs/vobject"
require "libs/card"

class Deck < VObject
  
  def initialize(name)
    super()
    @name = name
    @cards = []
  end
  
  def init
    @image = Surface.load("./images/#{@name}/back1.png")
    @image_lock = Surface.load("./images/lock.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def size
    return @cards.size
  end
  
  def menu_actions
    return ["Dai carta", "Mescola Mazzo", "Alza mazzo", "Riprendi carte"]
  end
  
end

class Deck1 < Deck
  
  def initialize(size = 54)
    super("deck1")
    case size
    when 40
      load_40
    when 52
      load_52
    else
      load_54
    end
  end
  
  def load_40
    @cards = []
    ["c", "q", "f", "p"].each do |s|
      (1..10).each do |n|
        @cards << [@name, s, n]
      end
    end
  end
  
  def load_52
    @cards = []
    ["c", "q", "f", "p"].each do |s|
      (1..13).each do |n|
        @cards << [@name, s, n]
      end
    end
  end
  
  def load_54
    load_52
    @cards << [@name, "r", 0]
    @cards << [@name, "b", 0]
  end
  
end
