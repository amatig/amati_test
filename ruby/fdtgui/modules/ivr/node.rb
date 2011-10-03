class FdtNode < Qt::GraphicsItem
  attr_reader :width, :height
  
  @@global_z = -1
  
  def self.getZfront()
    @@global_z += 1
    return @@global_z
  end
  
  def dialog(label)
    state = InputDialog::getItems(MyGraphicsView.instance, 
                                  label, 
                                  @memstorage)
    internal_checkChilds if state
    return state
  end
  
  def inputDialog()
    return dialog("Add node")
  end
  
  def editDialog()
    state = dialog("Edit #{@memstorage['Name'].value}")
    if state
      update # aggiorna dentro il nodo
      internal_fixPosChilds
    end
    return state
  end
  
  def getContextualMenu(popMenu)
    a2 = popMenu.addAction("Edit node")
    Qt::Object.connect(a2, SIGNAL(:triggered), Qt::Application.instance) {
      editDialog # il nodo si updata graficamente da solo
    }
    if (@type != "Begin" and @type != "End")
      a3 = popMenu.addAction("Delete node")
      Qt::Object.connect(a3, SIGNAL(:triggered), Qt::Application.instance) {
        nametemp = @memstorage['Name'].value
        ret = Qt::MessageBox.warning(@graph, "Alert", 
                                     "Sicuro di voler cancellare il nodo \'#{nametemp}\'?", 
                                     Qt::MessageBox::Yes, Qt::MessageBox::No)
        if ret == Qt::MessageBox::Yes
          delete
          @graph.scene.update # forza
        end
      }
    end
  end
  
  def internal_setGraphInfo(x = nil, y = nil)
    @graph = MyGraphicsView.instance # singleton
    
    begin
      @image = Qt::Image.new
      @image.load("#{$abs_path}/images/#{@raw_image}")
      if @image.width == 0
        @image.load("#{$abs_path}/images/Child") # default
      end
    rescue
    end
    
    @x = -@width / 2
    @y = -@height / 2
    
    setMove(true)
    setFlag(ItemSendsGeometryChanges)
    setCacheMode(DeviceCoordinateCache)
    setZValue(FdtNode.getZfront)
    
    if x == nil
      x = (155...480).to_a
      y = (150...350).to_a
      x = x[rand(x.length)] + @graph.horizontalScrollBar.value
      y = y[rand(y.length)] + @graph.verticalScrollBar.value
    end
    setPos(x, y)
    setToolTip(@memstorage["Name"].value)
    @graph.scene.addItem(self)
    
    # figli fissi key == al type nei raw_childs
    @raw_childs.each do |name, value|
      if value[0] == true # optional
        internal_addChild(name)
      end
    end
  end
  
  def internal_checkChild(name)
    widget = @memstorage[name]
    if (widget and (widget.class == Connector or widget.class == Dynamconnector) and widget.changed)
      if widget.value == true
        internal_addChild(name)
        widget.changed = false
      else
        if @childs.key?(name)
          @childs[name].delete
          @childs.delete(name)
        end
      end
    end
  end
  
  def internal_checkChilds
    @memstorage.each do |name, widget|
      internal_checkChild(name)
    end
  end
  
  def internal_addChild(name)
    begin
      index = @raw_childs[name][1]
      color = @raw_childs[name][2]
    rescue
      index = @childs.length + 2
      color = "#79bee5"
    end
    ch = FdtChildNode.getInstance(name, index, color)
    ch.setMove(false)
    @childs[name] = ch
  end
  
  def canJoin?()
    case @line_mode
    when "none"
      return false
    when "more"
      return true
    when "one"
      @edgeList.each do |e|
        return false if (e.sourceNode == self)
      end
      return true
    end
  end
  
  def addEdge(edge)
    unless edge.kind_of?(FdtJoinEdge)
      @edgeList << edge
      edge.adjust
    end
  end
  
  def removeEdge(edge)
    @edgeList.delete(edge)
  end
  
  def delete()
    @childs.values.each do |c|
      c.delete
    end
    @childs.clear
    while not @edgeList.empty?
      @edgeList[0].delete
    end
    @graph.scene.removeItem(self)
  end
  
  def setMove(value)
    setFlag(ItemIsMovable, value)
  end
  
  def boundingRect()
    adjust = 2
    if self.class == FdtChildNode
      return Qt::RectF.new(@x - adjust, @y - adjust,
                           @width + adjust + 2, @height + adjust + 2)
    else
      return Qt::RectF.new(@x - adjust - 50, @y - adjust,
                           @width + adjust + 150, @height + adjust + 22)
    end
  end
  
  def shape()
    path = Qt::PainterPath.new
    path.addRect(@x, @y, @width, @height);
    return path
  end
  
  def paint(painter, options, widget)
    if @image
      painter.drawImage(Qt::PointF.new(@x, @y), @image)
    else
      painter.setPen(Qt::Pen.new(Qt::Brush.new(Qt::black), 
                                 1, 
                                 Qt::SolidLine, 
                                 Qt::RoundCap, 
                                 Qt::RoundJoin))
      painter.setBrush(Qt::Brush.new(Qt::Color.new("#eee"), Qt::SolidPattern))
      painter.drawRect(@x, @y, @width, @height)
    end
    
    # Text
    if @memstorage["Description"]
      text = @memstorage["Description"].value
      fix = (text.length * 6.3 / 2) - (@width / 2)
      if type == "Child"
        textRect = Qt::RectF.new(@x + 8, @y + 5, @width - 7, @height - 7)
      else
        textRect = Qt::RectF.new(@x - fix, @height - 25, 200, 15)
      end
      font = painter.font
      font.family = "Monospace"
      # font.setBold(true)
      font.setPointSize(8)
      painter.setFont(font)
      painter.setPen(Qt::black)
      painter.drawText(textRect, text)
    end
  end
  
  def internal_fixPosChilds()
    temp = @childs.values.sort { |a, b| a.index <=> b.index }
    i = 0
    temp.each do |c|
      if @childs.length % 2 == 0
        shift = 30 * (Integer(@childs.length / 2) - 1) + 15
      else
        shift = 30 * Integer(@childs.length / 2)
      end
      case @memstorage["Layout"].value
      when "2" # top
        c.setPos(pos.x - shift + 30 * i, pos.y - 50)
      when "1" # left
        c.setPos(pos.x - 65, pos.y - shift + 30 * i)
      when "3" # right
        c.setPos(pos.x + @width - 10, pos.y - shift + 30 * i)
      else # bottom
        c.setPos(pos.x - shift + 30 * i, pos.y + @height + 10)
      end
      i += 1
    end
    @edgeList.each do |edge|
      edge.adjust
    end
    @graph.scene.update # forza update scena pericolo!!!!
  end
  
  def itemChange(change, value)
    case change
    when ItemPositionHasChanged
      internal_fixPosChilds
    end
    super(change, value)
  end
  
  def mousePressEvent(event)
    super(event)
    setZValue(FdtNode.getZfront)
    @childs.values.each do |c|
      c.setZValue(FdtNode.getZfront)
    end
    @graph.checkJoin(self) # check join mode
  end
  
  def mouseDoubleClickEvent(event)
    super
    if (self.class != FdtChildNode and event.button == 1)
      editDialog
    end
  end
  
  private :dialog
  
end

class FdtChildNode < FdtNode
  attr_reader :index, :color
  
  def getContextualMenu(popMenu)
    if canJoin?
      a1 = popMenu.addAction("New line")
      Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
        @graph.startJoin(self)
      }
    end
  end
  
  def mousePressEvent(event)
    super(event)
    @graph.startJoin(self) if (event.button == 1 and canJoin?)
  end
  
end

class FdtMouseNode < Qt::GraphicsItem
  attr_reader :width, :height
  
  def initialize
    super
    @width = 10
    @height = 10
  end
  
  def addEdge(edge)
  end
  
end
