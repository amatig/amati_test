class Deck < VObject
  attr_reader :cards_code, :cards_value
  
  def initialize(name)
    super()
    @name = name
    @cards_code = []
    @cards_value = []
    @x = 100
    @y = 300
    init_graph
  end
  
  def init_graph
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
    return [["1 carta", "action_1card"],
            ["1 carta a testa", "action_1card4all"], 
            ["2 carte a testa", "action_2card4all"], 
            ["3 carte a testa", "action_3card4all"], 
            ["5 carte a testa", "action_5card4all"], 
            ["Mazzo da 40", "action_create40"],
            ["Mazzo da 52", "action_create52"],
            ["Mazzo da 54", "action_create54"],
            ["Mescola", "action_shuffle"]]
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
    Env.instance.objects.each do |o|
      if o.kind_of?(Hand)
        action_1card(o.x + 20 + shift, o.y + 42)
      end
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
  
  def action_shuffle(data = nil)
    @cards_code = data if data
  end
  
  def action_create40(data = nil)
    if data
      Env.instance.del_all_card
      @cards_code = data
    end
  end
  
  def action_create52(data = nil)
    if data
      Env.instance.del_all_card
      @cards_code = data
    end
  end
  
  def action_create54(data = nil)
    if data
      Env.instance.del_all_card
      @cards_code = data
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
end