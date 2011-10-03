class ResourcesTree < Qt::TreeWidget
  
  def initialize
    super
    env = ProjectEnv.instance
    setHeaderLabels(["System Resources"])
    setAnimated(true)
    
    project = Qt::TreeWidgetItem.new
    project.setText(0, "Project")
    project.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(project)
    env.add_node(project.text(0), project, nil)
    
    r0 = Qt::TreeWidgetItem.new
    r0.setText(0, "ApplicationList")
    r0.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(r0)
    env.add_node(r0.text(0), r0, nil)
    
    r1 = Qt::TreeWidgetItem.new
    r1.setText(0, "VariableList")
    r1.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(r1)
    env.add_node(r1.text(0), r1, nil)
    
    r11 = Qt::TreeWidgetItem.new
    r11.setText(0, "ApplicationVariableList")
    r11.setIcon(0, Qt::Icon.new("#{$abs_path}/images/2nd.ico"))
    r1.insertChild(r1.childCount, r11)
    env.add_node(r11.text(0), r11, r1.text(0))
    
    r12 = Qt::TreeWidgetItem.new
    r12.setText(0, "ReservedVariableList")
    r12.setIcon(0, Qt::Icon.new("#{$abs_path}/images/2nd.ico"))
    r1.insertChild(r1.childCount, r12)
    env.add_node(r12.text(0), r12, r1.text(0))
    
    r2 = Qt::TreeWidgetItem.new
    r2.setText(0, "MessageFolderList")
    r2.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(r2)
    env.add_node(r2.text(0), r2, nil)
    
    r21 = Qt::TreeWidgetItem.new
    r21.setText(0, "MessageFolder")
    r21.setIcon(0, Qt::Icon.new("#{$abs_path}/images/2nd.ico"))
    r2.insertChild(r2.childCount, r21)
    env.add_node(r21.text(0), r21, r2.text(0))
    
    r3 = Qt::TreeWidgetItem.new
    r3.setText(0, "TimeProfileList")
    r3.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(r3)
    env.add_node(r3.text(0), r3, nil)
        
    r4 = Qt::TreeWidgetItem.new
    r4.setText(0, "DateProfileList")
    r4.setIcon(0, Qt::Icon.new("#{$abs_path}/images/1th.ico"))
    addTopLevelItem(r4)
    env.add_node(r4.text(0), r4, nil)
        
    # restricted
    v = Variable.new
    v.name = "reservedAgent"
    v.node_id = v.name
    v.description = "Porta IVR"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    v = Variable.new
    v.name = "reservedNow"
    v.node_id = v.name
    v.description = "Data ed Ora corrente"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    v = Variable.new
    v.name = "reservedLine"
    v.node_id = v.name
    v.description = "Linea IVR"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    v = Variable.new
    v.name = "reservedCLI"
    v.node_id = v.name
    v.description = "Numero del Chiamante"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    v = Variable.new
    v.name = "reservedCalledParty"
    v.node_id = v.name
    v.description = "Numero chiamato"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    v = Variable.new
    v.name = "reservedLanguage"
    v.node_id = v.name
    v.description = "Lingua corrente"
    v.type = "STRING"
    v.value = ""
    env.add(v, r12.text(0))
    
    expand_all
    collapseItem(project)
    collapseItem(r12)
  end
  
  def tree_context_menu(point)
    popMenu = MyMenu.new(self)
    pos = Qt::PointF.new(point.x + horizontalScrollBar.value, 
                         point.y + verticalScrollBar.value)
    item = self.itemAt(point)
    if item
      #if (item.text(0) == "ApplicationList")
      #  a1 = popMenu.addAction("Add Application")
      #  Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
      #    temp = Application.new
      #    if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
      #      ProjectEnv.instance.add(temp, item.text(0))
      #    end
      #  }
      #elsif (item.text(0) == "ApplicationVariableList")
      if (item.text(0) == "ApplicationVariableList")
        a1 = popMenu.addAction("Add Variable")
        Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
          temp = Variable.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
            ProjectEnv.instance.add(temp, item.text(0))
          end
        }
      elsif (item.text(0) == "TimeProfileList" or item.text(0) == "DateProfileList")
        name = item.text(0).gsub('List','')
        a1 = popMenu.addAction("Add #{name}")
        Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
          const = Kernel.const_get(name)
          temp = const.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
            n = ProjectEnv.instance.add(temp, item.text(0))
            expandItem(n)
          end
        }
      elsif (item.text(2) == "TimeProfile" or item.text(2) == "DateProfile")
        a1 = popMenu.addAction("Add #{item.text(2)} Detail")
        Qt::Object.connect(a1, SIGNAL(:triggered), Qt::Application.instance) {
          const = Kernel.const_get(item.text(2) + "Detail")
          temp = const.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{item.text(2)} Detail", temp)
            ProjectEnv.instance.add(temp, item.text(0))
          end
        }
      elsif (item.text(0) == "MessageFolder")
        a2 = popMenu.addAction("Add Message")
        Qt::Object.connect(a2, SIGNAL(:triggered), Qt::Application.instance) {
          temp = Message.new
          if InputDialog.sessionData(MyGraphicsView.instance, "Add #{temp.class.to_s}", temp)
            ProjectEnv.instance.add(temp, item.text(0))
          end
        }
      end
      temp = ProjectEnv.instance.get(item.text(2), item.text(1))
      if item.childCount == 0 and temp
        if temp.class.to_s != "TimeProfile" and temp.class.to_s != "DateProfile"
          a3 = popMenu.addAction("Edit")
          Qt::Object.connect(a3, SIGNAL(:triggered), Qt::Application.instance) {
            if (temp and InputDialog.sessionData(MyGraphicsView.instance, "Edit #{item.text(0)}", temp))
              item.setText(0, temp.name)
            end
          }
        end
        if (temp.class.to_s != "Setting" and temp.class.to_s != "Application") # temp. disabilitato del application
          a4 = popMenu.addAction("Delete")
          Qt::Object.connect(a4, SIGNAL(:triggered), Qt::Application.instance) {
            ret = Qt::MessageBox.warning(@graph, "Alert", "Sicuro di voler cancellare \'#{item.text(0)}\'?", Qt::MessageBox::Yes, Qt::MessageBox::No)
            if ret == Qt::MessageBox::Yes
              ProjectEnv.instance.del(item.text(2), item.text(1))
              if item.text(2) == "Application"
                MyGraphicsView.instance.clear_application
              end
            end
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
  
  def mouseDoubleClickEvent(event)
    super
    if (event.button == 1)
      item = itemAt(event.pos)
      if item and item.childCount <= 0
        temp = ProjectEnv.instance.get(item.text(2), item.text(1))
        if temp.class == Application
          MyGraphicsView.instance.change_application(temp.node_id)
        else
          if (temp and InputDialog.sessionData(MyGraphicsView.instance, "Edit #{temp.class.to_s}", temp))
            item.setText(0, temp.name)
          end
        end
      end
    end
  end
  
end

class MenuTree < Qt::TreeWidget
  
  def initialize
    super
    setHeaderLabels(["Widgets"])
    setAnimated(true)
    
    temp = {}
    
    Dir.glob("#{$abs_path}/modules/ivr/types/*xml") do |type|
      begin
        type = type.split("/").last[0..-5]
      rescue
      end
      file = File.new "#{$abs_path}/modules/ivr/types/#{type.downcase}.xml"
      doc = REXML::Document.new(file)      
      type = REXML::XPath.first(doc, "//type").text
      section = REXML::XPath.first(doc, "//section")
      
      if section
        section = section.text
        
        unless temp.has_key?(section)
          r = Qt::TreeWidgetItem.new
          r.setText(0, section)
          addTopLevelItem(r)
          temp[section] = r
        end
        sect = temp[section]
        
        r1 = Qt::TreeWidgetItem.new
        r1.setText(0, type)
        r1.setIcon(0, Qt::Icon.new("#{$abs_path}/images/#{type}.ico"))
        sect.insertChild(sect.childCount, r1)
      end
    end
    
    expand_all
  end
  
  def mouseDoubleClickEvent(event)
    super
    if (event.button == 1)
      item = itemAt(event.pos)
      if item and item.childCount <= 0
        MyGraphicsView.instance.createNode(item.text(0))
      end
    end
  end
  
end
