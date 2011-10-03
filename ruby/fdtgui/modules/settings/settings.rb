class MySettings < BaseModule
  
  def init
    list = findChild(Qt::TableWidget, "listserver")
    
    Qt::Object.connect(list, SIGNAL("itemChanged(QTableWidgetItem *)"), Qt::Application.instance) {
      row = list.currentRow
      if row >= 0
        insert_or_update(list, row)
      end
    }
    
    SystemSettings.getServers.each do |acc|
      list.insertRow(0)
      cb = Qt::ComboBox.new
      cb.addItem("LOCAL", Qt::Variant.new("/opt/build"))
      cb.addItem("DEBUG", Qt::Variant.new("remote:/opt/build"))
      cb.addItem("DEPLOY", Qt::Variant.new("remote:"))
      list.setCellWidget(0, 2, cb)
      
      c1 = Qt::TableWidgetItem.new
      c1.text = acc[1]
      list.setItem(0, 0, c1)
      list.item(0, 0).setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled)
      c2 = Qt::TableWidgetItem.new
      c2.text = acc[2]
      list.setItem(0, 1, c2)
      cb.setCurrentIndex(cb.findData(Qt::Variant.new(acc[3])))
      c4 = Qt::TableWidgetItem.new
      c4.text = acc[4]
      list.setItem(0, 3, c4)
      c5 = Qt::TableWidgetItem.new
      c5.text = acc[5]
      list.setItem(0, 4, c5)
      c6 = Qt::TableWidgetItem.new
      c6.text = acc[6]
      list.setItem(0, 5, c6)
    end
    
    add = findChild(Qt::PushButton, "addserver")
    Qt::Object.connect(add, SIGNAL(:clicked), Qt::Application.instance) {
      list.insertRow(0)
      cb = Qt::ComboBox.new
      cb.addItem("LOCAL", Qt::Variant.new("/opt/build"))
      cb.addItem("DEBUG", Qt::Variant.new("remote:/opt/build"))
      cb.addItem("DEPLOY", Qt::Variant.new("remote:"))
      list.setCellWidget(0, 2, cb)
    }
    
    del = findChild(Qt::PushButton, "delserver")
    Qt::Object.connect(del, SIGNAL(:clicked), Qt::Application.instance) {
      item = list.currentRow
      if item
        begin
          SystemSettings.delServer(list.item(item, 0).text)
        rescue
        end
        list.removeRow(item)
      end
    }
    
    save = findChild(Qt::PushButton, "saveserver")
    Qt::Object.connect(save, SIGNAL(:clicked), Qt::Application.instance) {
      insert_or_update(list)
    }
  end
  
  private
  
  def insert_or_update(list, r = nil)
    unless r
      elems = (0..list.rowCount).to_a
    else
      elems = [r]
    end
    elems.each do |row|
      name = list.item(row, 0) ? list.item(row, 0).text : ""
      desc = list.item(row, 1) ? list.item(row, 1).text : ""
      type = list.cellWidget(row, 2) ? list.cellWidget(row, 2).itemData(list.cellWidget(row, 2).currentIndex).toString : ""
      ip = list.item(row, 3) ? list.item(row, 3).text : ""
      user = list.item(row, 4) ? list.item(row, 4).text : ""
      passwd = list.item(row, 5) ? list.item(row, 5).text : ""
      if (ip and name and ip != "" and name != "")
        serv = SystemSettings.getServer(name)
        if (serv and serv.size > 0)
          SystemSettings.updateServer(name, desc, type, ip, user, passwd)
        else
          SystemSettings.addServer(name, desc, type, ip, user, passwd)
          list.item(row, 0).setFlags(Qt::ItemIsSelectable|Qt::ItemIsEnabled)
        end
      end
    end
  end
  
end
