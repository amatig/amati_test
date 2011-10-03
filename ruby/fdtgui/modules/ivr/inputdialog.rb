class InputDialog
  
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
        when "Adv_choice"
          memstorage[k].value = items[k][1].text
        when "Valuelist"
          temp_childs = {}
          memstorage.each do |key, value|
            temp_childs[key] = value if (value.class == Dynamconnector)
          end
          temp_row = []
          (0..items[k][1].count - 1).each do |row|            
            it = items[k][1].item(row)
            name = "On#{it.text}"
            temp_row << name
            unless temp_childs.key?(name)
              memstorage.add_entity(name, name, "Dynamconnector", false, true)
              memstorage[name].changed = true
            else
              memstorage[name] = true
            end
          end
          temp_childs.keys.each do |name|
            unless temp_row.include?(name)
              memstorage[name] = false
            end
          end
          memstorage[k].value = temp_row
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
          path = ""
          input = Qt::LineEdit.new(self)
          if value != ""
            input.setText(value.to_s)
            path = Pathname.new(value.to_s).dirname
          elsif $last_file
            path = Pathname.new($last_file).dirname
          end
          input.setGeometry(0, 0, 180, 25)
          input.move(165, 22 + 40 * i)
          filename = ""
          butt = Qt::PushButton.new(self)
          butt.setText("...")
          Qt::Object.connect(butt, SIGNAL(:clicked), Qt::Application.instance) {
            begin
              filename = dlg = Qt::FileDialog::getOpenFileName(nil, "Choice File", path, "Wav (*.wav);;All files (*.*)")
              if filename
                input.setText(filename)
                $last_file = filename
              end
            end
          }
          butt.setGeometry(0, 0, 23, 25)
          butt.move(360, 21 + 40 * i)
        when :type
          input = Qt::ComboBox.new(self)
          input.addItem("STRING", Qt::Variant.new("STRING"))
          input.addItem("INTEGER", Qt::Variant.new("INTEGER"))
          input.setCurrentIndex(input.findData(Qt::Variant.new(value)))
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        when :type_con
          input = Qt::ComboBox.new(self)
          input.addItem("LOCAL", Qt::Variant.new("/opt/build"))
          input.addItem("DEBUG", Qt::Variant.new("remote:/opt/build"))
          input.addItem("DEPLOY", Qt::Variant.new("remote:"))
          input.setCurrentIndex(input.findData(Qt::Variant.new(value)))
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        when :week
          input = Qt::ComboBox.new(self)
          input.addItem("Lunedi", Qt::Variant.new("LU"))
          input.addItem("Martedi", Qt::Variant.new("MA"))
          input.addItem("Mercoledi", Qt::Variant.new("ME"))
          input.addItem("Giovedi", Qt::Variant.new("GI"))
          input.addItem("Venerdi", Qt::Variant.new("VE"))
          input.addItem("Sabato", Qt::Variant.new("SA"))
          input.addItem("Domenica", Qt::Variant.new("DO"))
          input.addItem("Da Lunedi a Venerdi", Qt::Variant.new("S1"))
          input.addItem("Da Lunedi a Sabato", Qt::Variant.new("S2"))
          input.addItem("Sabato e Domenica", Qt::Variant.new("S3"))
          input.addItem("Tutti i Giorni", Qt::Variant.new("S4"))
          input.setCurrentIndex(input.findData(Qt::Variant.new(value)))
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        when :days
          input = Qt::SpinBox.new(self)
          input.setMinimum(1)
          input.setMaximum(31)
          input.setValue(value.to_i)
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        when :time
          input = Qt::TimeEdit.new(self)
          tt = value.split(":")
          input.setTime(Qt::Time.new(tt[0].to_i, tt[1].to_i, tt[2].to_i))
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        when :months
          input = Qt::ComboBox.new(self)
          input.addItem("Gennaio", Qt::Variant.new("1"))
          input.addItem("Febbraio", Qt::Variant.new("2"))
          input.addItem("Marzo", Qt::Variant.new("3"))
          input.addItem("Aprile", Qt::Variant.new("4"))
          input.addItem("Maggio", Qt::Variant.new("5"))
          input.addItem("Giugno", Qt::Variant.new("6"))
          input.addItem("Luglio", Qt::Variant.new("7"))
          input.addItem("Agosto", Qt::Variant.new("8"))
          input.addItem("Settembre", Qt::Variant.new("9"))
          input.addItem("Ottobre", Qt::Variant.new("10"))
          input.addItem("Novembre", Qt::Variant.new("11"))
          input.addItem("Dicembre", Qt::Variant.new("12"))
          input.setCurrentIndex(input.findData(Qt::Variant.new(value)))
          input.setGeometry(0, 0, 113, 25)
          input.move(165, 22 + 40 * i)
        else
          input = Qt::LineEdit.new(self)
          input.setText(value.to_s)
          input.setGeometry(0, 0, 200, 25)
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
