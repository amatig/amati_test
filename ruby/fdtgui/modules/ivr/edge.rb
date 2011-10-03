class FdtEdge < Qt::GraphicsItem
  Pi = 3.14159265358979323846264338327950288419717
  TwoPi = 2.0 * Pi
  
  def initialize(sourceNode, destNode)
    super()
    @graph = MyGraphicsView.instance # singleton
    
    @source = sourceNode
    @dest = destNode
    @sourcePoint = Qt::PointF.new
    @destPoint = Qt::PointF.new
    @source.addEdge(self)
    @dest.addEdge(self)
    @arrowSize = 10
    
    setAcceptedMouseButtons(0)
    setZValue(-2)
    adjust
  end
  
  def sourceNode()
    return @source
  end
  
  def setSourceNode(node)
    @source = node
    adjust
  end
  
  def destNode()
    return @dest
  end
  
  def setDestNode(node)
    @dest = node
    adjust
  end
  
  def delete()
    @source.removeEdge(self)
    @dest.removeEdge(self)
    @graph.scene.removeItem(self)
  end
  
  def getContextualMenu(popMenu)
    a4 = popMenu.addAction("Delete line")
    Qt::Object.connect(a4, SIGNAL(:triggered), Qt::Application.instance) {
      ret = Qt::MessageBox.warning(@graph, "Alert", "Sicuro di voler cancellare la linea?", Qt::MessageBox::Yes, Qt::MessageBox::No)
      if ret == Qt::MessageBox::Yes
        delete
        @graph.scene.update # forza
      end
    }
  end
  
  def adjust()
    return if not @source or not @dest
    
    line = Qt::LineF.new(mapFromItem(@source, 0, 0), mapFromItem(@dest, 0, 0))
    length = line.length
    
    return if length == 0.0 # messo io come in python
    
    prepareGeometryChange
    
    if length > 25
      x = @dest.width / 1.4 # distanza dal centro
      y = @dest.height / 1.3
      edgeOffset = Qt::PointF.new(line.dx * x / length, line.dy * y / length)
      @sourcePoint = line.p1
      @destPoint = line.p2 - edgeOffset
    else
      @sourcePoint = line.p1
      @destPoint = line.p1
    end
  end
  
  def boundingRect()
    return Qt::RectF.new if not @source or not @dest
    
    penWidth = 1
    extra = penWidth + @arrowSize / 2.0
    
    rect = Qt::RectF.new(@sourcePoint, 
                         Qt::SizeF.new(@destPoint.x - @sourcePoint.x,
                                       @destPoint.y - @sourcePoint.y))
    rect.normalized
    rect.adjusted(-extra, -extra, extra, extra)
    return rect
  end
  
  def paint(painter, options, widget)
    return if not @source or not @dest
    
    line = Qt::LineF.new(@sourcePoint, @destPoint)
    #return if qFuzzyCompare(line.length, 0.0)
    return if line.length == 0.0 # forse come sopra per sicurezza :D
    
    # Draw the line itself
    painter.setPen(Qt::Pen.new(Qt::Brush.new(Qt::Color.new(@source.color)), 
                               1, 
                               Qt::SolidLine, 
                               Qt::RoundCap, 
                               Qt::RoundJoin))
    painter.drawLine line
    
    # Draw the arrows
    angle = Math.acos(line.dx / line.length)
    if line.dy >= 0
      angle = TwoPi - angle
    end
    
    destArrowP1 = Qt::PointF.new(@destPoint + Qt::PointF.new(Math.sin(angle - Pi / 3) * @arrowSize,
                                                             Math.cos(angle - Pi / 3) * @arrowSize))
    destArrowP2 = Qt::PointF.new(@destPoint + Qt::PointF.new(Math.sin(angle - Pi + Pi / 3) * @arrowSize,
                                                             Math.cos(angle - Pi + Pi / 3) * @arrowSize))
    painter.setBrush(Qt::Brush.new(Qt::Color.new(@source.color), Qt::SolidPattern))
    painter.drawPolygon(Qt::PolygonF.new([line.p2, destArrowP1, destArrowP2]))
  end

  def serialize
  end
  
end

class FdtJoinEdge < FdtEdge  
end
