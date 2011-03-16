class InputDialog < Qt::Dialog
    
  def InputDialog.getItems(parent, title = "Input", memstorage = {})
    items = {}
    
    dlg = Qt::Dialog.new(parent) do
      setWindowTitle(title)
      i = 0
      
      i, temp_items = memstorage.get_group("Ungrouped").add_widget(i, self)
      items.update(temp_items)      
      # per essere sicuro che i gruppi stanno dopo
      memstorage.groups.each do |name, group|
        if group.class != Ungrouped
          i, temp_items = group.add_widget(i, self)
          items.update(temp_items)
        end
      end
      
      resize(425, 80 + 40 * i + 10) # ridimensionamento finestra
      
      save = Qt::PushButton.new(self)
      save.setText("Save")
      save.move(165, 30 + 40 * i + 10)
      Qt::Object.connect(save, SIGNAL(:clicked), Qt::Application.instance) do
        flag = true
        items.each do |k, v|
          temp = memstorage[k].is_valid?(v[1])
          flag = (flag and temp)
          unless temp
            v[1].setStyleSheet("QLineEdit { background-color: #fb6666 }");
          else
            v[1].setStyleSheet("QLineEdit { background-color: white }");
          end
        end
        accept() if flag
      end
      cancel = Qt::PushButton.new(self)
      cancel.setText("Cancel")
      cancel.move(265, 30 + 40 * i + 10)
      Qt::Object.connect(cancel, SIGNAL(:clicked), Qt::Application.instance) { reject() }
    end
    
    if dlg.exec == Qt::Dialog::Accepted
      items.keys.each do |k|
        case items[k][0]
        when "Text", "Wav"
          memstorage[k].value = items[k][1].text
        when "Memo"
          memstorage[k].value = items[k][1].toPlainText
        when "Int"
          memstorage[k].value = items[k][1].text.to_i
        when "Choice"
          memstorage[k].value = items[k][1].itemData(items[k][1].currentIndex).toString
        when "Bool", "Connector"
          if items[k][1].respond_to?("checkState")
            memstorage[k].value = (items[k][1].checkState == 2)
          else
            memstorage[k].value = (items[k][1].isChecked)
          end
        end
      end
      return true
    else
      return false
    end
  end
  
  def InputDialog.sessionData(parent, title, obj)
    items = []
    dlg = Qt::Dialog.new(parent) do
      setWindowTitle(title)
      i = 0
      obj.get_fields.each do |name, value, type|
        label = Qt::Label.new(self)
        label.setText(name)
        label.move(30, 27 + 40 * i)
        case type
        when :memo
          input = Qt::TextEdit.new(self)
          input.setText(value.to_s)
          input.setGeometry(0, 0, 218, 62)
          input.move(165, 22 + 40 * i)
          i += 1
        when :wav
          input = Qt::LineEdit.new(self)
          input.setText(value.to_s)
          input.setGeometry(0, 0, 180, 25)
          input.move(165, 22 + 40 * i)
          filename = ""
          butt = Qt::PushButton.new(self)
          butt.setText("...")
          Qt::Object.connect(butt, SIGNAL(:clicked), Qt::Application.instance) {
            begin
              filename = dlg = Qt::FileDialog::getOpenFileName(nil, "Choice File", "", "All files (*.*);;")
              input.setText(filename) if filename
            end
          }
          butt.setGeometry(0, 0, 23, 25)
          butt.move(360, 21 + 40 * i)
        when :type
          input = Qt::ComboBox.new(self)
          input.addItem("STRING", Qt::Variant.new(0))
          input.addItem("INTEGER", Qt::Variant.new(1))
          input.setCurrentIndex(value.to_i)
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        else
          input = Qt::LineEdit.new(self)
          input.setText(value.to_s)
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        end
        items << input
        i += 1
      end
      save = Qt::PushButton.new(self)
      save.setText("Save")
      save.move(165, 30 + 40 * i + 10)
      Qt::Object.connect(save, SIGNAL(:clicked), Qt::Application.instance) do
        obj.set_fields(items)
        accept
      end
      cancel = Qt::PushButton.new(self)
      cancel.setText("Cancel")
      cancel.move(265, 30 + 40 * i + 10)
      Qt::Object.connect(cancel, SIGNAL(:clicked), Qt::Application.instance) { reject() }
    end
    
    if dlg.exec == Qt::Dialog::Accepted
      return true
    else
      return false
    end
  end
  
end
