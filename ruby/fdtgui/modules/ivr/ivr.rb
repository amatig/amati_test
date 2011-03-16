require "rexml/document"
require "singleton"
require "forwardable"
require "modules/ivr/clip_board"
require "modules/ivr/canvas"
require "modules/ivr/tree"
require "modules/ivr/entity"
require "modules/ivr/memstorage"
require "modules/ivr/project_env"
require "modules/ivr/inputdialog"
require "modules/ivr/node"
require "modules/ivr/meta_node"
require "modules/ivr/edge"

class IvrWidget < Qt::Widget
  
  def initialize()
    super()
    @graph = MyGraphicsView.instance
    
    splitter = Qt::Splitter.new
    splitter.add_widget(MenuTree.new)
    splitter.add_widget(@graph)
    splitter.add_widget(ResourcesTree.new)
    
    self.layout = Qt::VBoxLayout.new
    self.layout.add_widget(splitter)
  end
  
  def init_toolbar(toolbar)
    new_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-new.png")
    open_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-open.png")
    save_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-save.png")
    saveas_pix = Qt::Icon.new("/usr/share/icons/gnome/32x32/actions/document-save-as.png")
    
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
  end

end

