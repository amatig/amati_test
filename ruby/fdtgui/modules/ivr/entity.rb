# -*- coding: utf-8 -*-
# GROUPS

class BaseGroup < Hash
end

class Ungrouped < BaseGroup
  attr_reader :ordered
  
  def initialize(*args)
    super
    @ordered = []
  end
  
  def []=(key, value)
    super
    @ordered << [key, value]
  end
  
  def add_widget(i, graph)
    items = {}
    @ordered.each do |tupla|
      next if tupla[1].class == Dynamconnector
      label = Qt::Label.new(graph)
      label.setText(tupla[0])
      label.move(30, 27 + 40 * i)
      i, input = tupla[1].add_widget(i, graph)
      items[tupla[0]] = [tupla[1].class.to_s, input]
      i += 1
    end
    return i, items
  end
  
end

class Simple < Ungrouped
end

class Numpad < BaseGroup
  attr_reader :ordered
  
  def initialize(*args)
    super
    @ordered = []
  end
  
  def []=(key, value)
    super
    @ordered << [key, value]
  end
  
  def add_widget(i, graph)
    items = {}
    j = 0
    z = 0
    @ordered.each do |tupla|
      mod = j % 3
      input = Qt::PushButton.new(graph)
      input.setText(tupla[0].gsub("OnChoice", "").gsub("Pound", "#").gsub("Star", "*"))
      input.setGeometry(0, 0, 25, 25)
      input.setCheckable(true)
      input.setChecked(tupla[1].value)
      input.move(165 + 28 * mod, 22 + 40 * i + 27 * z)
      items[tupla[0]] = [tupla[1].class.to_s, input]
      j += 1
      z += 1 if (mod == 2)
    end
    i += 3
    return i, items
  end
  
end

# WIDGETS

class Input
  attr_accessor :changed, :slabel
  
  def initialize(def_val, not_null)
    @value = def_val
    @changed = false
    @not_null = not_null
    @slabel = ""
  end
  
  def add_widget(i, graph)
    return i, nil
  end
  
  def value=(value)
    @changed = (@value != value)
    @value = value
  end
  
  def value
    return @value
  end
  
  def is_valid?(input)
    flag = true
    if @not_null
      flag = (flag and input.text != "")
    end
    return flag
  end
  
end

class Text < Input
  
  def initialize(def_val, not_null)
    super
    @value = "" unless @value
  end
  
  def add_widget(i, graph)
    input = Qt::LineEdit.new(graph)
    input.setText(@value) if @value
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    return i, input
  end
  
  def is_valid?(input)
    flag = super
    if @not_null
      flag = (flag and ((input.text =~ /\w+/) != nil))
    end
    return flag
  end
  
end

class Digit < Input
  
  def add_widget(i, graph)
    input = Qt::LineEdit.new(graph)
    input.setText(@value) if @value
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    return i, input
  end
  
  def is_valid?(input)
    flag = super
    if @not_null
      flag = (flag and ((input.text =~ /[0-9#*+]+/) != nil))
    end
    return flag
  end
  
end

class Memo < Text
  
  def add_widget(i, graph)
    input = Qt::TextEdit.new(graph)
    input.setText(@value) if @value
    input.setGeometry(0, 0, 218, 62)
    input.move(165, 22 + 40 * i)
    i += 1
    return i, input
  end
  
end

class Valuelist < Input
  
  def initialize(def_val, not_null)
    super
    @value = [] unless @value
  end
  
  def addChild(row)
    @value << row
  end
  
  def add_widget(i, graph)    
    input = Qt::ListWidget.new(graph)
    input.setGeometry(0, 0, 190, 135)
    input.move(165, 25 + 40 * i)
    padd = Qt::PushButton.new(graph)
    padd.setText("+")
    padd.setGeometry(0, 0, 24, 24)
    padd.move(374, 25 + 40 * i)
    pdel = Qt::PushButton.new(graph)
    pdel.setText("-")
    pdel.setGeometry(0, 0, 24, 24)
    pdel.move(374, 55 + 40 * i)
    
    @value.each do |row|
      r = Qt::ListWidgetItem.new(row[2..-1]) # elimina On
      r.setIcon(Qt::Icon.new("#{$abs_path}/images/Variable.ico"))
      input.addItem(r)
    end
    
    Qt::Object.connect(padd, SIGNAL(:clicked), Qt::Application.instance) {
      text = Qt::InputDialog.getText(graph, "New Value", "Enter Value")
      if text
        r = Qt::ListWidgetItem.new(text)
        r.setIcon(Qt::Icon.new("#{$abs_path}/images/Variable.ico"))
        input.addItem(r)
      end
    }
    Qt::Object.connect(pdel, SIGNAL(:clicked), Qt::Application.instance) {
      item = input.currentRow
      if item
        input.takeItem(item)
      end
    }
    
    i += 3
    return i, input
  end
  
end

class Choice < Input
  attr_reader :choice

  def initialize(def_val, not_null)
    super
    @choice = def_val ? def_val : []
    @temp = @choice
    @value = ""
  end
  
  def add_widget(i, graph)
    input = Qt::ComboBox.new(graph)
    
    case @choice
    when "status"
      @temp = [["off", "OFF"], ["On", "ON"]]
    when "grammar"
      @temp = [["Digits", "DIGITS"],]
    when "transfer"
      @temp = [["Blind", "BLIND"], ["Consultation", "CONSULTATION"]]
    when "position"
      @temp = [["Bottom", "0"], ["Left", "1"], ["Top", "2"], ["Right", "3"]]
    when "logic_operations"
      @temp = [["=", "=="], ["<>", "!="], [">", ">"], [">=", ">="], ["<", "<"], ["<=", "<="]]
    when "math_operations"
      @temp = [["Ripristina", "Restore"], ["Somma", "+"], 
               ["Moltiplica", "*"], ["Concatena", "Concat"], 
               ["Imposta", "Allocation"], ["Sottrai", "-"], 
               ["Dividi", "/"], ["Anteponi", "Prepend"],
               ["Estrai", "Extract"]]
    when "resource_wav"
      @temp = ProjectEnv.instance.getResourceWav
    when "resource_timeprofile"
      @temp = ProjectEnv.instance.getResourceTimeProfile
    when "resource_dateprofile"
      @temp = ProjectEnv.instance.getResourceDateProfile
    when "digits_acquire"
      @temp = [["Fix", "Fix"], ["Terminated", "Terminated"]]
    end
    
    @temp.each do |v|
      input.addItem(v[0], Qt::Variant.new(v[1]))
    end
    
    begin
      if @value != ""
        input.setCurrentIndex(input.findData(Qt::Variant.new(@value)))
      else
        input.setCurrentIndex(0)
      end
    rescue
    end
    
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    return i, input
  end
  
end

class Adv_choice < Input
  
  def initialize(def_val, not_null)
    super
    @choice = def_val
    @value = ""
  end
  
  def add_widget(i, graph)
    input = Qt::ComboBox.new(graph)
    input1 = Qt::ComboBox.new(graph)
    input1.hide
    if ((@choice =~ /\_value/) != nil)
      input2 = Qt::LineEdit.new(graph)
      input2.hide
    end
    buffer = Qt::LineEdit.new(graph)
    buffer.setText(@value)
    buffer.hide
    
    # populate first combo
    input.addItem("App. Variable", Qt::Variant.new(0))
    if ((@choice =~ /\_reserv/) != nil)
      input.addItem("Res. Variable", Qt::Variant.new(1))
    end
    if ((@choice =~ /\_value/) != nil)
      input.addItem("Value", Qt::Variant.new(2))
    end
    
    # populate second combo
    if (@value == "" or ((@value =~ /^ApplicationVariable/) != nil))
      temp = ProjectEnv.instance.getResourceAppVar
      temp.each do |v|
        input1.addItem(v[0], Qt::Variant.new(v[1]))
      end
      input.setCurrentIndex(input.findData(Qt::Variant.new(0)))
      input1.show
      input1.setCurrentIndex(input1.findData(Qt::Variant.new(@value)))
    elsif (@value == "" or ((@value =~ /^ReservedVariable/) != nil))
      temp = ProjectEnv.instance.getResourceResVar
      temp.each do |v|
        input1.addItem(v[0], Qt::Variant.new(v[1]))
      end
      input.setCurrentIndex(input.findData(Qt::Variant.new(1)))
      input1.show
      input1.setCurrentIndex(input1.findData(Qt::Variant.new(@value)))
    else
      input.setCurrentIndex(input.findData(Qt::Variant.new(2)))
      input2.show
      input2.setText(@value.gsub("Value§§", ""))
    end
    
    Qt::Object.connect(input, SIGNAL("currentIndexChanged(int)"), Qt::Application.instance) {
      case input.itemData(input.currentIndex())
      when Qt::Variant.new(0)
        input1.clear
        temp = ProjectEnv.instance.getResourceAppVar
        temp.each do |v|
          input1.addItem(v[0], Qt::Variant.new(v[1]))
        end
        begin
          input2.hide
        rescue
        end
        input1.show
        buffer.setText(input1.itemData(input1.currentIndex).toString)
      when Qt::Variant.new(1)
        input1.clear
        temp = ProjectEnv.instance.getResourceResVar
        temp.each do |v|
          input1.addItem(v[0], Qt::Variant.new(v[1]))
        end
        begin
          input2.hide
        rescue
        end
        input1.show
        buffer.setText(input1.itemData(input1.currentIndex).toString)        
      when Qt::Variant.new(2)
        input1.hide
        input2.show
        buffer.setText("Value§§#{input2.text}")
      end
    }
    Qt::Object.connect(input1, SIGNAL("currentIndexChanged(int)"), Qt::Application.instance) {
      buffer.setText(input1.itemData(input1.currentIndex).toString)
    }
    if ((@choice =~ /\_value/) != nil)
      Qt::Object.connect(input2, SIGNAL("textEdited(const QString &)"), Qt::Application.instance) {
        buffer.setText("Value§§#{input2.text}")
      }
    end
    
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    input1.setGeometry(0, 0, 113, 25)
    input1.move(285, 22 + 40 * i)
    if ((@choice =~ /\_value/) != nil)
      input2.setGeometry(0, 0, 113, 25)
      input2.move(285, 22 + 40 * i)
    end
    return i, buffer
  end
  
end

class Int < Input
  
  def initialize(def_val, not_null)
    super
    @value = 0 unless @value
  end
  
  def add_widget(i, graph)
    input = Qt::LineEdit.new(graph)
    input.setText(@value.to_s) if @value
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    return i, input
  end
  
  def is_valid?(input)
    flag = super
    if @not_null
      flag = (flag and ((input.text =~ /\d+/) != nil))
    end
    return flag
  end
  
end

class Wav < Input
  
  def initialize(def_val, not_null)
    super
    @value = "" unless @value
  end
  
  def add_widget(i, graph)
    path = ""
    input = Qt::LineEdit.new(graph)
    if @value
      input.setText(@value)
      path = Pathname.new(@value).dirname
    elsif $last_file
      path = Pathname.new($last_file).dirname
    end
    input.setGeometry(0, 0, 180, 25)
    input.move(165, 22 + 40 * i)
    filename = ""
    butt = Qt::PushButton.new(graph)
    butt.setText("...")
    Qt::Object.connect(butt, SIGNAL(:clicked), Qt::Application.instance) {
      begin
        filename = dlg = Qt::FileDialog::getOpenFileName(nil, "Choice File", path, "All files (*.*);;")
        if filename
          input.setText(filename)
          $last_file = filename
        end
      end
    }
    butt.setGeometry(0, 0, 23, 25)
    butt.move(360, 21 + 40 * i)
    return i, input
  end
  
  def is_valid?(input)
    flag = super
    if @not_null
      flag = (flag and ((input.text =~ /\w+/) != nil)) # validare un path
    end
    return flag
  end
  
end

class Bool < Input
  
  def initialize(def_val, not_null)
    super
    @value = false unless @value
  end
  
  def add_widget(i, graph)
    input = Qt::CheckBox.new(graph)
    input.setChecked(@value)
    input.move(165, 26 + 40 * i)
    return i, input
  end
  
  def value=(value)
    v = (value == "True" or value == "true" or value == true)
    super(v)
  end
  
end

class Connector < Bool  
end

class Dynamconnector < Connector
end
