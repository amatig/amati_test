class MyProcess < BaseModule
  
  def init
    @refresh_time = 6000
    
    bReset = findChild(Qt::PushButton, "pushReset")
    Qt::Object.connect(bReset, SIGNAL(:clicked), Qt::Application.instance) {
      command("-r")
    }
    bStart = findChild(Qt::PushButton, "pushStart")
    Qt::Object.connect(bStart, SIGNAL(:clicked), Qt::Application.instance) {
      command("-s")
    }
    bStop = findChild(Qt::PushButton, "pushStop")
    Qt::Object.connect(bStop, SIGNAL(:clicked), Qt::Application.instance) {
      command("-k")
    }
    bRefresh = findChild(Qt::PushButton, "pushRefresh")
    Qt::Object.connect(bRefresh, SIGNAL(:clicked), Qt::Application.instance) {
      refresh
    }
    
    refresh
  end
  
  def refresh
    begin
      process = query
    rescue
      process = []
    end
    process = [] unless process
    
    list = findChild(Qt::ListWidget, "listWidget")
    list.clear
    list.setSortingEnabled(true)
    
    process.each do |p|
      begin
        name, status = p.split("=>")
        r = Qt::ListWidgetItem.new(name + "    [  " + status + "  ]")
        r.setIcon(Qt::Icon.new("#{$abs_path}/images/#{status}.ico"))
        list.addItem(r)
      rescue
        puts p
      end
    end
    
  end
  
  private
  
  def query
    result = ""
    setting = SystemSettings.getConnectServer()
    unless setting
      return
    end
    user = setting[5]
    passwd = setting[6]
    ip = setting[4]
    path = setting[3]
    if path =~ /remote\:/
      if user and passwd and ip
        path = path.gsub("remote:", "")
        Net::SSH.start(ip, user, :password => passwd) do |ssh|
          if path =~ /opt\/build/
            result = ssh.exec!(path + "/bin/sipxproc")
          else
            result = ssh.exec!("sipxproc")
          end
        end
      end
    else
      result = %x[#{path}/bin/sipxproc]
    end
    result.delete! "\{|\}|\"\ |\n"
    return result.split(",")
  end
  
  def command(cmd)
    process = ""
    list = findChild(Qt::ListWidget, "listWidget")
    begin
      process = list.currentItem.text.split(" ")[0]
    rescue
      return
    end
    
    result = ""
    setting = SystemSettings.getConnectServer()
    unless setting
      return
    end
    user = setting[5]
    passwd = setting[6]
    ip = setting[4]
    path = setting[3]
    if path =~ /remote\:/
      if user and passwd and ip
        path = path.gsub("remote:", "")
        Net::SSH.start(ip, user, :password => passwd) do |ssh|
          if path =~ /opt\/build/
            result = ssh.exec!(path + "/bin/sipxproc #{cmd} #{process}")
          else
            result = ssh.exec!("sipxproc #{cmd} #{process}")
          end
        end
      end
    else
      result = %x[#{path}/bin/sipxproc #{cmd} #{process}]
    end
    result.delete! "\{|\}|\"\ |\n"
    name, status = result.split("=>")
    if status != "true"
      Qt::MessageBox.critical(self, "Error", "Riavvio del processo #{process} fallito!")
    end
    refresh
  end
  
end
