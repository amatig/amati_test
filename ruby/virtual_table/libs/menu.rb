class Menu
  
  def initialize(pos, vobject)
    # dati font
    TTF.setup
    font = TTF.new("./fonts/FreeSans.ttf", 12)
    # dati della grafica
    @items = []
    space = 0
    vobject.menu_actions.each do |item|
      i = Surface.load("./images/menu1.jpg")
      ri = i.make_rect
      t = font.render_utf8(item, true, [0x00, 0x00, 0x00])
      rt = t.make_rect
      ri.x = pos[0]
      ri.y = pos[1] + space * 20
      rt.x = pos[0] + 5
      rt.y = pos[1] + space * 20 + 3
      @items << [i, ri, t, rt]
      space += 1
    end
  end
  
  def draw(screen)
    @items.each do |i, r, t, rt|
      i.blit(screen, r)
      t.blit(screen, rt)
    end
  end
  
end
