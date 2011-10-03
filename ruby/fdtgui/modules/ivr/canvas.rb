class MyGraphicsView < Qt::GraphicsView
  include Singleton
  
  slots "on_context_menu(const QPoint&)"
  
  def setWindow(window)
    @window = window
    @progressLabel = @window.findChild(Qt::Label, "label")
    @progressBar = @window.findChild(Qt::ProgressBar, "progressBar")
    @progressLabel.hide
    @progressBar.hide
    @progressBar.setMinimum(0)
    @progressBar.setMaximum(100)
    @progressBar.value = 0    
    @progress_value = 0
  end
  
  def update_progress
    @progressBar.value = @progress_value
  end
  
  def refresh_progress(num)
    @progressBar.setMaximum(num + 1)
  end
  
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
    @current_application = nil # application
    
    # popup
    setContextMenuPolicy(Qt.CustomContextMenu)
    Qt::Object.connect(self,
                       SIGNAL("customContextMenuRequested(const QPoint&)"), 
                       self, 
                       SLOT("on_context_menu(const QPoint&)"))
    
    # scale(2.8, 2.8)
  end
    
  def setVisible(*args)
    super
    new(true, true)
  end
  
  def alert_save
    ret = Qt::MessageBox.warning(self, "Alert", "Il progetto corrente non e\' stato salvato! Se non salvato verranno perse tutte le modifiche. Salvarlo ora?", Qt::MessageBox::Save, Qt::MessageBox::Discard, Qt::MessageBox::Cancel)
    case ret
    when Qt::MessageBox::Save
      save
      return true
    when Qt::MessageBox::Discard
      return true
    when Qt::MessageBox::Cancel
      return false
    end
  end
  
  def new(flag = true, save = false)
    unless save
      unless alert_save
        return
      end
    end
    
    scene.clear
    @join = nil
    @project = nil
    
    ProjectEnv.instance.clear
    
    if flag
      temp = Application.new
      temp.name = "Nuova Applicazione"
      ProjectEnv.instance.add(temp, "ApplicationList")
      @current_application = temp.node_id
      
      loadNode("Begin")
      loadNode("End")
      
      # project setting
      ProjectEnv.instance.loadSettings(nil)
    end
  end
  
  def open()
    unless alert_save
      return
    end
    
    begin
      path = ""
      if @project
        path = Pathname.new(@project).dirname
      end
      filename = dlg = Qt::FileDialog::getOpenFileName(MyGraphicsView.instance, "Open File", path, "Xml (*.xml);;All files (*.*)")
      return if not filename
    rescue Exception => e
      puts e
      return
    end
    
    new(false, true)
    @project = filename
    
    file = File.new filename
    doc = REXML::Document.new file
    
    penv = ProjectEnv.instance
    res = REXML::XPath.first(doc,"//Project")
    if res
      penv.load(res)
    end
    
    fapp = REXML::XPath.first(doc,"//Application")
    @current_application = fapp.attributes["ID"]
    load_application
    
    file.close
  end
  
  def clear_application()
    scene.clear
    @join = nil
  end
  
  def load_application()
    # per ora riesce a caricare + application se sono gia in un xml
    # non da nuovo progetto
    if @project
      clear_application
      
      clip = ClipBoard.instance
      clip.destroy
      
      file = File.new @project
      doc = REXML::Document.new file
      
      fapp = REXML::XPath.first(doc,"//Application[@ID='#{@current_application}']")
      if fapp
        REXML::XPath.each(fapp, "*/Block") do |node|
          FdtNode.loadInstance(node)
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
      end
    end
  end
  
  def change_application(id)
    @current_application = id
    load_application
  end
  
  def current_application()
    return @current_application
  end
  
  def export()
    setting = SystemSettings.getConnectServer()
    unless setting
      Qt::MessageBox.warning(self, "Alert", "Export del file annullato. Assicurarsi di aver salvato il progetto ed stabilito una connessione ad un server!")
      return
    end
    user = setting[5]
    passwd = setting[6]
    ip = setting[4]
    path = setting[3]
    
    if path =~ /remote\:/
      if user and passwd and ip and @project
        save
        return unless check
        
        lista_wav = ProjectEnv.instance.getResourceMessage
        refresh_progress(lista_wav.length)
        @progress_value = 0
        update_progress
        @progressLabel.show
        @progressBar.show
        
        #puts "0 #{Time.new.to_i}"
        block = Proc.new {
          Thread.pass
          Net::SSH.start(ip, user, :password => passwd) do |ssh|
            begin
              dest_path = Pathname.new(lista_wav[0][1]).dirname
              ssh.exec!("mkdir -p #{dest_path}")
            rescue Exception => e
            end
            
            path = path.gsub("remote:", "")
            #puts "1 #{Time.new.to_i}"
            ssh.scp.upload!(@project, path + "/etc/sipxpbx/ivr.xml")
            #puts "2 #{Time.new.to_i}"
            @progress_value += 1
            update_progress
            #puts "3 #{Time.new.to_i}"
            
            lista_wav.each do |o, d|
              #puts "*4 #{Time.new.to_i}"
              if File.exists?(o)
                #puts "*5 #{Time.new.to_i}"
                ssh.scp.upload!(o, d)
                #puts "*6 #{Time.new.to_i}"
              end
              @progress_value += 1
              update_progress
              #puts "*7 #{Time.new.to_i}"  
            end
            
            #puts "8 #{Time.new.to_i}"
            
            if path =~ /opt\/build/
              result = ssh.exec!(path + "/bin/sipxproc -r fdtIvr")
            else
              result = ssh.exec!("sipxproc -r fdtIvr")
            end
          end
          @progressLabel.hide
          @progressBar.hide
        }
        timer=Qt::Timer.new(self)
        invoke=Qt::BlockInvocation.new(timer, block, "invoke()")
        Qt::Object.connect(timer, SIGNAL("timeout()"), invoke, SLOT("invoke()"))
        timer.setSingleShot(true)
        timer.start(1)
        
        #puts "9 #{Time.new.to_i}" 
      else
        Qt::MessageBox.warning(self, "Alert", "Export del file annullato. Assicurarsi di aver salvato il progetto ed stabilito una connessione ad un server!")
      end
    else
      if @project
        save
        return unless check 
        
        lista_wav = ProjectEnv.instance.getResourceMessage
        refresh_progress(lista_wav.length)
        @progress_value = 0
        update_progress
        @progressLabel.show
        @progressBar.show
        
        block = Proc.new {
          Thread.pass
          
          begin
            dest_path = Pathname.new(lista_wav[0][1]).dirname
            %x[mkdir -p #{dest_path}]
          rescue Exception => e
          end
          
          if (@project != "#{path}/etc/sipxpbx/ivr.xml")
            FileUtils.cp(@project, "#{path}/etc/sipxpbx/ivr.xml")
          end
          @progress_value += 1
          update_progress
          
          lista_wav.each do |o, d|
            FileUtils.cp(o, d) if File.exists?(o)
            @progress_value += 1
            update_progress
          end
          
          %x[#{path}/bin/sipxproc -r fdtIvr]
          
          @progressLabel.hide
          @progressBar.hide
        }
        
        timer=Qt::Timer.new(self)
        invoke=Qt::BlockInvocation.new(timer, block, "invoke()")
        Qt::Object.connect(timer, SIGNAL("timeout()"), invoke, SLOT("invoke()"))
        timer.setSingleShot(true)
        timer.start(1)
      else
        Qt::MessageBox.warning(self, "Alert", "Export del file annullato. Assicurarsi di aver salvato il progetto ed stabilito una connessione ad un server!")
      end
    end
  end
  
  def check()
    result = true
    file = File.new @project
    doc = REXML::Document.new file
    find_conn = REXML::XPath.first(doc,"//Connector[@NextBlock='']")
    if find_conn
      Qt::MessageBox.warning(self, "Alert", "Export del file annullato. Flusso IVR invalido.")
      result = false
    end
    REXML::XPath.each(doc,"//Block[@Type='PLAYMESSAGE']") { | node |
      unless node.attributes["PlayMessage"]
        Qt::MessageBox.warning(self, "Alert", "Export del file annullato. A PlayMessage Node senza messaggio audio associato.")
        result = false
      end
    }
    return result
  end

  def save(flag = false)
    if not @project or flag
      begin
        path = ""
        if @project
          path = Pathname.new(@project).dirname
        end
        filename = dlg = Qt::FileDialog::getSaveFileName(MyGraphicsView.instance, "Save File", path, "Xml (*.xml);;All files (*.*)")
        return if not filename
        unless filename =~ /\.xml/
          filename += ".xml"
        end
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
    rl = REXML::Element.new "ResouceList"
    doc.add_element dh
    dh.add_element pj
    pj.add_element al
    pj.add_element rl
    
    penv = ProjectEnv.instance
    penv.serialize(pj)
    
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
          a5 = popMenu.addAction(Qt::Icon.new("#{$abs_path}/images/#{type}.ico"), type)
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
      if (@join.sourceNode != node and node.type != "Begin" and
          node.class != FdtChildNode and not node.childs.values.include?(@join.sourceNode))
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
