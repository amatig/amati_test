#!/usr/bin/ruby

require "Qt4"
require "qtuitools"
require "modules/ivr/ivr"

module MyMainWindow
  
  def my_init(w, h)
    setWindowTitle "Fdt Suite Manager"
    resize(w, h)
    center(w, h)
    
    toolbar = findChild(Qt::ToolBar, "mainToolBar")
    
    tab = findChild(Qt::TabWidget, "tabWidget")
    Qt::Object.connect(tab, SIGNAL("currentChanged(int)"), Qt::Application.instance) {
      widget = tab.widget(tab.currentIndex)
      toolbar.hide
      toolbar.clear
      if widget.respond_to?("init_toolbar")
        widget.init_toolbar(toolbar)
        toolbar.show
      end
    }
    
    tab.addTab(IvrWidget.new, "Ivr Configurator")
    Dir.glob("widgets/*.ui").each do |filename|
      # load gui
      file = Qt::File.new(filename)
      file.open(Qt::File::ReadOnly)
      loader = Qt::UiLoader.new
      widget = loader.load(file, nil)
      file.close
      begin
        filename = filename.split("/").last[0..-4]
      rescue
      end
      # extend gui
      require "modules/#{filename}/#{filename}"
      widget.extend(Kernel.const_get(filename.capitalize))
      widget.my_init(self)
      tab.addTab(widget, filename.capitalize)
    end
    
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
window.my_init(1024, 700)

app.exec
