#!/usr/bin/ruby

require 'rubygems'
require "Qt4"
require "qtuitools"
require "zip/zipfilesystem"
require "zip/ziprequire"
require "pathname"
require "sqlite3"
require "system_settings"
require "modules/base_module"

module Kernel
  def get_resource(resourceName, &aProc)
    zl = ZipList.new($:.grep(/\.dat$/))
    zl.get_input_stream(resourceName, &aProc)
  end
end

pn = Pathname.new($0)
$abs_path = pn.dirname

$:.unshift "#{$abs_path}/modules.dat" if File.exist?("#{$abs_path}/modules.dat")
require "modules/ivr/ivr"

module MyMainWindow
  
  def my_init(w, h)
    unless File.exist?("#{$abs_path}/settings.sqlite")
      SystemSettings.db_first_connection("#{$abs_path}/settings.sql")
    else
      SystemSettings.db_connection
    end
    
    s = SystemSettings.getConnectServer
    if s
      setWindowTitle "Fdt Suite Manager - #{s[1]}:#{s[4]}"
    else
      setWindowTitle "Fdt Suite Manager"
    end
    
    resize(w, h)
    center(w, h)
    
    menuConnect = findChild(Qt::Action, "actionConnect")
    menuConnect.menu = Qt::Menu.new
    actExit = findChild(Qt::Action, "actionExit")
    Qt::Object.connect(actExit, SIGNAL("triggered()"), Qt::Application.instance) {
      Qt::Application.quit
    }
    
    # menu connection
    timer_conn = Qt::Timer.new(self)
    Qt::Object.connect(timer_conn, SIGNAL("timeout()"), Qt::Application.instance) {
      menuServ = Qt::Menu.new
      SystemSettings.getServers.each do |s|
        act = Qt::Action.new(s[1], self)
        Qt::Object.connect(act, SIGNAL("triggered()"), Qt::Application.instance) {
          serv = SystemSettings.setConnectServer(act.text)
          setWindowTitle "Fdt Suite Manager - #{serv[0]}:#{serv[1]}"
        }
        menuServ.addAction(act)
      end
      menuConnect.menu = menuServ
    }
    timer_conn.start(1000)
    
    tab = findChild(Qt::TabWidget, "tabWidget")
    
    Dir.glob("modules/*/").sort.each do |filename|
      filename = filename.split("/")[1]
      require "modules/#{filename}/#{filename}"
      mod = Kernel.const_get("My#{filename.capitalize}").new(self)
      tab.addTab(mod, filename.capitalize)
    end    
    
    @timer = Qt::Timer.new(self)
    Qt::Object.connect(@timer, SIGNAL("timeout()"), Qt::Application.instance) {
      update_timer
    }
    
    Qt::Object.connect(tab, SIGNAL("currentChanged(int)"), Qt::Application.instance) {
      update_tab
    }
    
    update_tab
    show
    @timer.start(100000)
  end
  
  private
  
  def update_timer
    tab = findChild(Qt::TabWidget, "tabWidget")
    widget = tab.widget(tab.currentIndex)
    begin
      widget.refresh
    rescue
    end    
  end
  
  def update_tab
    toolbar = findChild(Qt::ToolBar, "mainToolBar")
    tab = findChild(Qt::TabWidget, "tabWidget")
    
    widget = tab.widget(tab.currentIndex)
    
    toolbar.hide
    toolbar.clear
    begin
      widget.init_toolbar
      @timer.setInterval(widget.refresh_time)
      toolbar.show
    rescue
    end
  end
  
  def center(w, h)
    qdw = Qt::DesktopWidget.new
    move((qdw.width - w) / 2, (qdw.height - h) / 2)
  end
    
end


if __FILE__ == $0
  begin
    app = Qt::Application.new(ARGV)
    app.setWindowIcon(Qt::Icon.new("#{$abs_path}/images/Main.ico"))
    
    file = Qt::File.new("#{$abs_path}/gui.ui")
    file.open(Qt::File::ReadOnly)
    loader = Qt::UiLoader.new
    window = loader.load(file, nil)
    file.close
    
    window.extend(MyMainWindow)
    window.my_init(1024, 700)
    
    app.exec
  rescue Interrupt
  rescue Exception => e
    puts e
    puts e.backtrace
  ensure
  end
end
