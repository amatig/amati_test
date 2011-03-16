module Prova
  
  def my_init(window)
    b1 = findChild(Qt::PushButton, "pushButton")
    Qt::Object.connect(b1, SIGNAL(:clicked), Qt::Application.instance) { prova }
  end
  
  def prova()
    puts "provaaaa"
  end
  
end
