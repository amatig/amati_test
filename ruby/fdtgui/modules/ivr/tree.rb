class MyTreeWidget < Qt::TreeWidget
  
  def initialize
    super
    env = ProjectEnv.instance
    setHeaderLabels(["System Resources"])
    setAnimated(true)
    
    r1 = Qt::TreeWidgetItem.new
    r1.setText(0, "VariableList")
    r1.setIcon(0, Qt::Icon.new("images/1th.ico"))
    addTopLevelItem(r1)
    env.add_node(r1.text(0), r1, nil)
    
    r11 = Qt::TreeWidgetItem.new
    r11.setText(0, "ApplicationVariableList")
    r11.setIcon(0, Qt::Icon.new("images/2nd.ico"))
    r1.insertChild(r1.childCount, r11)
    env.add_node(r11.text(0), r11, r1.text(0))
    
    r12 = Qt::TreeWidgetItem.new
    r12.setText(0, "ReservedVariableList")
    r12.setIcon(0, Qt::Icon.new("images/2nd.ico"))
    r1.insertChild(r1.childCount, r12)
    env.add_node(r12.text(0), r12, r1.text(0))
    
    r2 = Qt::TreeWidgetItem.new
    r2.setText(0, "MessageFolderList")
    r2.setIcon(0, Qt::Icon.new("images/1th.ico"))
    addTopLevelItem(r2)
    env.add_node(r2.text(0), r2, nil)
    
    r21 = Qt::TreeWidgetItem.new
    r21.setText(0, "MessageFolder")
    r21.setIcon(0, Qt::Icon.new("images/2nd.ico"))
    r2.insertChild(r2.childCount, r21)
    env.add_node(r21.text(0), r21, r2.text(0))
    
    expand_all
  end
  
  def tree_context_menu(point)
    popMenu = MyMenu.new(self)
    pos = Qt::PointF.new(point.x + horizontalScrollBar.value, 
                         point.y + verticalScrollBar.value)
    item = self.itemAt(point)
    if item
      if (item.text(0) == "ReservedVariableList" or item.text(0) == "ApplicationVariableList")
        a1 = popMenu.addAction("Add Variables")
        Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
          temp = Variable.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
            ProjectEnv.instance.add(temp, item.text(0))
          end
        }
      elsif (item.text(0) == "MessageFolder")
        a2 = popMenu.addAction("Add Messages")
        Qt::Object.connect(a2, SIGNAL(:triggered), Qt::Application.instance) {
          temp = Message.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
            ProjectEnv.instance.add(temp, item.text(0))
          end
        }
      else
        if item.childCount == 0
          a3 = popMenu.addAction("Edit")
          Qt::Object.connect(a3, SIGNAL(:triggered), Qt::Application.instance) {
            temp = ProjectEnv.instance.get(item.text(2), item.text(1))
            if InputDialog.sessionData(MyGraphicsView.instance, "Edit #{temp.class.to_s}", temp)
              item.setText(0, temp.name)
            end
          }
          a4 = popMenu.addAction("Delete")
          Qt::Object.connect(a4, SIGNAL(:triggered), Qt::Application.instance) {
            ProjectEnv.instance.del(item.text(2), item.text(1))
          }
        end
      end
    end
    popMenu.exec(mapToGlobal(point)) unless popMenu.isEmpty
  end
  
  def mousePressEvent(event)
    super
    if (event.button == 2)
      tree_context_menu(event.pos)
    end
  end
  
end
