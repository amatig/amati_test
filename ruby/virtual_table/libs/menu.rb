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
      t = font.render_utf8(label, true, [0, 0, 0])
      r = i.make_rect
      r.topleft = [pos[0], pos[1] + space * 20]
      @items << [i, t, r, label, method]
      space += 1
    end
  end
  
  def select(ev)
    @items.each do |item|
      if item[2].collide_point?(*ev.pos)
        @choice = item[4]
        break
      else
        @choice = nil
      end
    end
  end
  
  def draw(screen)
    @items.each do |item|
      if choice == item[4]
        s = Surface.load("./images/menu2.jpg")
        s.blit(screen, item[2])
      else
        item[0].blit(screen, item[2])
      end
      item[1].blit(screen, [item[2][0] + 5, item[2][1] + 3])
    end
  end
  
end
