class MyGraphicsView < Qt::GraphicsView
  include Singleton
  
  slots "on_context_menu(const QPoint&)"
  
  def initialize()
    super()
    scene = Qt::GraphicsScene.new(self)
    scene.setItemIndexMethod(Qt::GraphicsScene::NoIndex)
    scene.setSceneRect(0, 0, 5000, 3000)
    setScene(scene)
    setCacheMode(CacheBackground)
    setViewportUpdateMode(BoundingRectViewportUpdate)
    setRenderHint(Qt::Painter::Antialiasing)
    setTransformationAnchor(AnchorUnderMouse)
    setResizeAnchor(AnchorViewCenter)
    
    @mouse = FdtMouseNode.new # mouse entity
    @join = nil # link join istance
    @project = nil # progetto aperto
    
    # popup
    setContextMenuPolicy(Qt.CustomContextMenu)
    Qt::Object.connect(self,
                       SIGNAL("customContextMenuRequested(const QPoint&)"), 
                       self, 
                       SLOT("on_context_menu(const QPoint&)"))
    # scale(2.8, 2.8)
  end
  
  def new(flag = true)
    scene.clear
    ProjectEnv.instance.clear
    @join = nil
    @project = nil
    if flag
      loadNode("Begin")
      loadNode("End")
    end
  end
  
  def open()
    begin
      filename = dlg = Qt::FileDialog::getOpenFileName(nil, "Open File", "", "Xml (*.xml);;")
      return if not filename
    rescue Exception => e
      puts e
      return
    end
    
    new(false)
    @project = filename
    
    clip = ClipBoard.instance
    clip.destroy
    file = File.new filename
    doc = REXML::Document.new file
    penv = ProjectEnv.instance
    res = REXML::XPath.first(doc,"//ResouceList")
    if res
      penv.load(res)
    end
    
    REXML::XPath.each(doc, "//Block") do |node|
      tmp = FdtNode.loadInstance(node)
    end
    
    clip.clip.each do | arch |
      my_dest = nil
      scene.items.each do |node|
        if node.id == arch[1]
          my_dest = node
          break
        end
      end
      if my_dest != nil
        e = FdtEdge.new(arch[0], my_dest)
        scene.addItem(e)
      end
    end
    file.close
  end
  
  def save(flag = false)
    if not @project or flag
      begin
        filename = dlg = Qt::FileDialog::getSaveFileName(nil, "Save File", "", "Xml (*.xml);;")
        return if not filename
        @project = filename
      rescue Exception => e
        puts e
        return
      end
    else
      filename = @project
    end
    
    doc = REXML::Document.new "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    dh = REXML::Element.new "DocumentHeader"
    pj = REXML::Element.new "Project"
    al = REXML::Element.new "ApplicationList"
    ap = REXML::Element.new "Application"
    fb = REXML::Element.new "FlowBlocks"
    rl = REXML::Element.new "ResouceList"
    doc.add_element dh
    dh.add_element pj
    pj.add_element al
    al.add_element ap
    ap.add_element fb
    pj.add_element rl
    scene.items.each do |i|
      node = i.serialize()
      fb.add_element node if node
    end
    penv = ProjectEnv.instance
    penv.serialize(rl)
    file = File.new(filename, File::CREAT|File::TRUNC|File::RDWR)
    doc.write(file, 2)
    file.close
  end
  
  def on_context_menu(point)
    return if @join
    popMenu = MyMenu.new(self)
    pos = Qt::PointF.new(point.x + horizontalScrollBar.value, 
                         point.y + verticalScrollBar.value)
    item = scene.itemAt(pos)
    if item
      item.getContextualMenu(popMenu)
    else
      Dir.glob("modules/ivr/types/*xml") do |type|
        begin
          type = type.split("/").last[0..-5]
        rescue
        end
        file = File.new "modules/ivr/types/#{type.downcase}.xml"
        doc = REXML::Document.new(file)      
        type = REXML::XPath.first(doc, "//type").text
        section = REXML::XPath.first(doc, "//section")        
        if section
          a5 = popMenu.addAction(Qt::Icon.new("images/#{type}.ico"), type)
          Qt::Object.connect(a5, SIGNAL(:triggered), Qt::Application.instance) {
            createNode(type)
          }
        end
      end
    end
    popMenu.exec(mapToGlobal(point)) unless popMenu.isEmpty
  end
  
  def createNode(type)
    FdtNode.createInstance(type) unless @join
  end
  
  def loadNode(type)
    FdtNode.getInstance(type) unless @join
  end
  
  def startJoin(node)
    @join = FdtJoinEdge.new(node, @mouse)
    node.setZValue(FdtNode.getZfront)
    scene.addItem(@join)
  end
  
  def finishJoin()
    scene.removeItem(@join)
    @join = nil
    scene.update # forza update
  end
  
  def checkJoin(node)
    if @join
      if (node != @join.sourceNode and node.type != "Begin" and node.type != "Child")
        scene.addItem(FdtEdge.new(@join.sourceNode, node))
      end
      finishJoin
    end
  end
  
  def keyPressEvent(event)
    super event
    if (event.key == 16777216 and @join)
      finishJoin
    end
  end
  
  def mouseMoveEvent(event)
    super event
    pos = Qt::PointF.new(event.x + horizontalScrollBar.value, 
                         event.y + verticalScrollBar.value)
    @mouse.setPos(pos) # lasciare fuori se no guasta grafica
    if @join
      @join.adjust
      scene.update # forza update scena necessario!!!!
    end
  end
  
  #def drawBackground(painter, rect)
  #  painter.setPen(Qt::Pen.new(Qt::Brush.new(Qt::Color.new("#eee")), 
  #                             1, 
  #                             Qt::SolidLine, 
  #                             Qt::RoundCap, 
  #                             Qt::RoundJoin))
  #  painter.drawRect(sceneRect)
  #end
end

class MyMenu < Qt::Menu
  
  def mousePressEvent(event)
    if (event.button == 1)
      super
    else
      close
    end
  end
  
end
