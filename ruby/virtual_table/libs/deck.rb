require "libs/vobject"
require "libs/card"

class Deck < VObject
  
  def initialize(name)
    super()
    @name = name
    @cards = []
    @x = 100
    @y = 300
  end
  
  def init
    @image = Surface.load("./images/#{@name}/deck1.png")
    @image_lock = Surface.load("./images/lock.png")
    @image_empty = Surface.load("./images/#{@name}/deck2.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
    
  def size
    return @cards.size
  end
  
  def menu_actions
    return [["Dai carta", "action_card"], 
            ["Mescola mazzo", "action_shuffle"], 
            ["Riprendi carte", "action_new"]]
  end
  
  def action_card
    unless @cards.empty?
      c = Card.new(*@cards.delete(@cards.first))
      c.init if @image # se e' un client
      c.set_pos(@x + 90, @y + 2)
      Env.instance.add_object(c)
    end
  end
  
  def action_shuffle(data = nil)
    if @image
      # e' un client
      @cards = data if data
    else
      # e' nel server
      @cards.shuffle!
      return @cards
    end
  end
  
  def action_new
    Env.instance.del_all_card
    create
  end
  
  # Ridefinizione del metodo per il deck.
  def draw(screen)
    unless @cards.empty?
      @image.blit(screen, @rect)
    else
      @image_empty.blit(screen, @rect)
    end
    @image_lock.blit(screen, @rect) if @lock
  end
  
end

class DeckPoker < Deck
  
  def initialize(size = 54)
    super("deck1")
    @max_size = size # salva il num di carte
    create
  end
  
  def create
    case @max_size
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
