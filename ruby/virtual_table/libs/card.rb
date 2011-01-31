require "libs/vobject"
require "libs/secret_deck"

class Card < VObject
  attr_reader :seed, :num
  
  def initialize(deck, code)
    super()
    @oid = code # serve un indice unico
    @deck = deck
    @seed = nil
    @num = nil
    @turn = false
  end
  
  def init
    if (@seed == nil and @num == nil)
      @image = Surface.load("./images/#{@deck}/deck2.png")
    else
      @image = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    end
    @image_back = Surface.load("./images/#{@deck}/back1.png")
    @image_lock = Surface.load("./images/lock.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def set_value(val)
    @seed = val[0]
    @num = val[1]
    if @image
      @image = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    end
  end
  
  def menu_actions
    return [["Gira carta", "action_turn"]]
  end
  
  def action_turn(data = nil)
    if @image
      # e' nel client
      if data
        set_value(data)
        @turn = (not @turn)
      end
    else
      # e' nel server
      val = SecretDeck.instance.get_value(oid)
      set_value(val)
      @turn = (not @turn)
      return val
    end
  end
  
  # Ridefinizione del metodo per il deck.
  def draw(screen)
    hand = Env.instance.hands
    if (@turn == false and not hand.rect.collide_rect?(@rect))
      @image_back.blit(screen, @rect)
    else
      @image.blit(screen, @rect)
    end
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
