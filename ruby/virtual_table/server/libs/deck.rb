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
  
  def size
    return @cards_code.size
  end
  
  def action_1card(x = nil, y = nil)
    unless @cards_code.empty?
      c = Card.new(@name, @cards_code.delete(@cards_code.first))
      if (x and y)
        c.set_pos(x, y)
      else
        c.set_pos(@x + 90, @y + 2)
      end
      Env.instance.add_object(c)
    end
  end
  
  def action_1card4all(shift = 0)
    Env.instance.hands.values.each do |h|
      action_1card(h.x + 20 + shift, h.y + 42)
    end
  end
  
  def action_2card4all
    (0..1).each do |n|
      action_1card4all(n * 35)
    end
  end
  
  def action_3card4all
    (0..2).each do |n|
      action_1card4all(n * 35)
    end
  end
  
  def action_5card4all
    (0..4).each do |n|
      action_1card4all(n * 35)
    end
  end
  
  def action_shuffle
    return @cards_code.shuffle!
  end
  
  def action_create40
    Env.instance.del_all_card
    create(40)
    return @cards_code
  end
  
  def action_create52
    Env.instance.del_all_card
    create(52)
    return @cards_code
  end
  
  def action_create54
    Env.instance.del_all_card
    create(54)
    return @cards_code
  end
  
end

class DeckPoker < Deck
  
  def initialize
    super("deck1")
    create
  end
  
  def create(size = 54)
    @cards_code = []
    (1..size).each do |n|
      code = (0...10).collect { rand(10) }.join
      @cards_code.push(code)
    end
    
    @cards_value = []
    (1..13).each do |num|
      ["c", "q", "f", "p"].each do |seed|
        @cards_value.push([seed, num])
      end
    end
    @cards_value.push(["r", 0])
    @cards_value.push(["b", 0])
    
    SecretDeck.instance.create(self)
    @cards_code.shuffle!
  end
  
end