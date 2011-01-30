require "singleton"

class SecretDeck
  include Singleton
  
  def create(deck)
    @secret_cards = {}
    deck.cards_code.each do |code|
      value = deck.cards_value.delete(deck.cards_value.first)
      @secret_cards[code] = value
    end
  end
  
  def get_value(code)
    return @secret_cards[code]
  end
  
end
