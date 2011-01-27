require "libs/vobject"

class Card < VObject
  attr_reader :deck, :seed, :num
  
  def initialize(deck, s, n)
    super()
    @oid = "#{deck}_#{s}_#{n}" # server un indice unico
    @deck = deck
    @seed = s
    @num = n
    @turn = false
  end
  
  def init
    @image = Surface.load("./images/#{@deck}/#{@seed}#{@num}.png")
    @image_lock = Surface.load("./images/lock.png")
    @image_back = Surface.load("./images/#{@deck}/back1.png")
    @rect = @image.make_rect
    set_pos(@x, @y)
    return self
  end
  
  def menu_actions
    return [["Gira per te", "action_turn_me"], 
            ["Gira per tutti", "action_turn_all"]]
  end
  
  def action_turn_me
    
  end
  
  def action_turn_all
    @turn = (not @turn)
  end
  
  # Ridefinizione del metodo per il deck.
  def draw(screen)
    unless @turn
      @image_back.blit(screen, @rect)
    else
      @image.blit(screen, @rect)
    end
    @image_lock.blit(screen, @rect) if @lock
  end
  
end
