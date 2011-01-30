require "libs/vobject"
require "libs/secret_deck"
require "libs/card"

class Deck < VObject
  attr_reader :cards_code, :cards_value
  
  def initialize(name)
    super()
    @name = name
    @cards_code = []
    @cards_value = []
    @x = 100
    @y = 300
  end
  
  def init
    @image = Surface.load("./images/#{@name}/deck1.png")
    @image_empty = Surface.load("./images/#{@name}/deck2.png")
    @image_lock = Surface.load("./images/lock.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def size
    return @cards_code.size
  end
  
  def menu_actions
    return [["Dai carta", "action_card"], 
            ["Mescola mazzo", "action_shuffle"], 
            ["Riprendi carte", "action_create"]]
  end
  
  def action_card
    unless @cards_code.empty?
      c = Card.new(@name, @cards_code.delete(@cards_code.first))
      c.init if @image # se e' un client
      c.set_pos(@x + 90, @y + 2)
      Env.instance.add_object(c)
    end
  end
  
  def action_shuffle(data = nil)
    if @image
      # e' un client
      @cards_code = data if data
    else
      # e' nel server
      @cards_code.shuffle!
      return @cards_code
    end
  end
  
  def action_create(data = nil)
    Env.instance.del_all_card
    if @image
      # e' un client
      @cards_code = data if data
    else
      # e' nel server
      create
      return @cards_code
    end
  end
  
  # Ridefinizione del metodo per il deck.
  def draw(screen)
    unless @cards_code.empty?
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
    @cards_code = []
    (1..@max_size).each do |n|
      code = (0...10).collect { rand(10) }.join
      @cards_code.push(code)
    end
    
    @cards_value = []
    ["c", "q", "f", "p"].each do |seed|
      (1..13).each do |num|
        @cards_value.push([seed, num])
      end
    end
    @cards_value.push(["r", 0])
    @cards_value.push(["b", 0])
    
    SecretDeck.instance.create(self)
    @cards_code.shuffle!
  end
  
end
