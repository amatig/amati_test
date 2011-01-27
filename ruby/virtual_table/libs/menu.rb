class Menu
  attr_reader :choice
  
  def initialize(pos, vobject)
    @choice = nil # azione scelta dal menu
    # dati font
    TTF.setup
    font = TTF.new("./fonts/FreeSans.ttf", 12)
    # dati della grafica
    @items = []
    space = 0
    vobject.menu_actions.each do |label, method|
      i = Surface.load("./images/menu1.jpg")
      ri = i.make_rect
      t = font.render_utf8(label, true, [0x00, 0x00, 0x00])
      rt = t.make_rect
      ri.x = pos[0]
      ri.y = pos[1] + space * 20
      rt.x = pos[0] + 5
      rt.y = pos[1] + space * 20 + 3
      @items << [i, ri, t, rt, label, method]
      space += 1
    end
  end
  
  def select(ev)
    @items.each do |item|
      if item[1].collide_point?(*ev.pos)
        @choice = item[5]
        break
      else
        @choice = nil
      end
    end
  end
  
  def draw(screen)
    @items.each do |i, r, t, rt|
      i.blit(screen, r)
      t.blit(screen, rt)
    end
  end
  
end
