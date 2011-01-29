require "libs/vobject"

class Card < VObject
  attr_reader :deck, :seed, :num
  
  def initialize(deck, seed, num)
    super()
    @oid = "#{deck}_#{seed}_#{num}" # server un indice unico
    @deck = deck
    @seed = seed
    @num = num
    @turn = false
  end
  
  def init
    @image = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    @image_back = Surface.load("./images/#{@deck}/back1.png")
    @image_lock = Surface.load("./images/lock.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def menu_actions
    return [["Gira carta", "action_turn"]]
  end
  
  def action_turn
    @turn = (not @turn)
  end
  
  # Ridefinizione del metodo per il deck.
  def draw(screen)
    hand = Env.instance.hand
    if (@turn == false and not hand.rect.collide_rect?(@rect))
      @image_back.blit(screen, @rect)
    else
      @image.blit(screen, @rect)
    end
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
