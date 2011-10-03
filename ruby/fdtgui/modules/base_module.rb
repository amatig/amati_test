class BaseModule < Qt::Widget
  attr_reader :refresh_time
  
  def initialize(window)
    super()
    @window = window
    @refresh_time = 100000
    
    file = Qt::File.new("widgets/#{self.class.to_s.downcase[2..-1]}.ui")
    file.open(Qt::File::ReadOnly)
    loader = Qt::UiLoader.new
    widget = loader.load(file, nil)
    file.close
    self.layout = Qt::GridLayout.new
    self.layout.add_widget(widget)
    
    init
    init_toolbar # force init qt after load xml
  end
  
  def init_toolbar
    toolbar = @window.findChild(Qt::ToolBar, "mainToolBar")
    exit_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/application-exit.png")
    
    e1 = toolbar.addAction(exit_pix, "Exit")
    Qt::Object.connect(e1, SIGNAL(:triggered), Qt::Application.instance) {
      Qt::Application.quit
    }
  end
  
  def init
  end
  
  def refresh
  end
  
end
