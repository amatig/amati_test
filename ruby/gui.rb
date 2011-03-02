#!/usr/bin/ruby

require "Qt4"
require "qtuitools"

module MyMainWindow
  
  def my_init(w, h)
    setWindowTitle "Fdt Suite Manager"
    resize(w, h)
    center(w, h)
    
    act_quit = findChild(Qt::Action, "actionQuit")
    connect(act_quit, SIGNAL(:triggered), Qt::Application.instance, SLOT("quit()"))
    
    show
  end
  
  def center(w, h)
    qdw = Qt::DesktopWidget.new
    move((qdw.width - w) / 2, (qdw.height - h) / 2)
  end
  
end

app = Qt::Application.new(ARGV)

file = Qt::File.new("gui.ui")
file.open(Qt::File::ReadOnly)
loader = Qt::UiLoader.new
window = loader.load(file, nil)
file.close

window.extend(MyMainWindow)
window.my_init(800, 600)

app.exec
