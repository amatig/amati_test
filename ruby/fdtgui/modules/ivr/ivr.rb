require "rexml/document"
require "net/scp"
require "pathname"
require "singleton"
require "forwardable"
require "modules/ivr/clip_board"
require "modules/ivr/canvas"
require "modules/ivr/tree"
require "modules/ivr/entity"
require "modules/ivr/memstorage"
require "modules/ivr/project_env"
require "modules/ivr/inputdialog"
require "modules/ivr/progressdialog"
require "modules/ivr/node"
require "modules/ivr/meta_node"
require "modules/ivr/edge"

class MyIvr < Qt::Widget
  attr_reader :refresh_time
  
  def initialize(window)
    super()
    @window = window
    @refresh_time = 100000
    
    menu = MenuTree.new
    res = ResourcesTree.new
    @graph = MyGraphicsView.instance
    @graph.setWindow(@window)
    
    splitter = Qt::Splitter.new
    
    splitter.add_widget(menu)
    splitter.add_widget(@graph)
    splitter.add_widget(res)
    
    #splitter.setStretchFactor(1, 100)
    
    self.layout = Qt::VBoxLayout.new
    self.layout.add_widget(splitter)
  end
  
  def init_toolbar
    toolbar = @window.findChild(Qt::ToolBar, "mainToolBar")
    
    new_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-new.png")
    open_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-open.png")
    save_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-save.png")
    saveas_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-save-as.png")
    exp_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-send.png")
    exit_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/application-exit.png")
        
    a1 = toolbar.addAction(new_pix, "New")
    Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
      @graph.new
    }
    a2 = toolbar.addAction(open_pix, "Open")
    Qt::Object.connect(a2, SIGNAL(:triggered), Qt::Application.instance) {
      @graph.open
    }
    a3 = toolbar.addAction(save_pix, "Save")
    Qt::Object.connect(a3, SIGNAL(:triggered), Qt::Application.instance) {
      @graph.save
    }
    a4 = toolbar.addAction(saveas_pix, "Save as")
    Qt::Object.connect(a4, SIGNAL(:triggered), Qt::Application.instance) {
      @graph.save(true)
    }
    a5 = toolbar.addAction(exp_pix, "Export")
    Qt::Object.connect(a5, SIGNAL(:triggered), Qt::Application.instance) {
      @graph.export
    }
    e1 = toolbar.addAction(exit_pix, "Exit")
    Qt::Object.connect(e1, SIGNAL(:triggered), Qt::Application.instance) {
      Qt::Application.quit
    }
  end
  
  def refresh
  end
  
end
