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
  
  def set_value(val)
    @seed = val[0]
    @num = val[1]
  end
  
  def action_turnoff
    @turn = false
  end
  
  def action_turn
    val = SecretDeck.instance.get_value(oid)
    set_value(val)
    @turn = (not @turn)
    return val
  end
  
  def action_take(data)
    set_pos(*data)
  end
  
end
