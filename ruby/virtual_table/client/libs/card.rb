class Card
  attr_reader :seed, :number
  attr_accessor :x, :y
  
  def initialize(deck, s, n)
    @images = Surface.load("./images/#{deck}/#{s}#{n}.png")
    @seed = s
    @number = n
    @x = 0
    @y = 0
  end
  
  def draw(screen)
    @images.blit(screen, [@x, @y])
  end
  
end
