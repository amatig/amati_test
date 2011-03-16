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
  attr_accessor :changed
  
  def initialize(def_val, not_null)
    @value = def_val
    @changed = false
    @not_null = not_null
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
      flag = (flag and (input.text =~ /\w+/))
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

class Choice < Input
  
  def initialize(def_val, not_null)
    super
    @choice = def_val ? def_val : []
    @value = @choice.first
  end
  
  def add_widget(i, graph)
    input = Qt::ComboBox.new(graph)
    index = 0
    @choice.each do |name|
      input.addItem(name, Qt::Variant.new(index))
      index += 1
    end
    input.setCurrentIndex(@value.to_i)
    input.setGeometry(0, 0, 113, 25)
    input.move(165, 22 + 40 * i)
    return i, input
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
      flag = (flag and (input.text =~ /\d+/))
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
    input = Qt::LineEdit.new(graph)
    input.setText(@value) if @value
    input.setGeometry(0, 0, 180, 25)
    input.move(165, 22 + 40 * i)
    filename = ""
    butt = Qt::PushButton.new(graph)
    butt.setText("...")
    Qt::Object.connect(butt, SIGNAL(:clicked), Qt::Application.instance) {
      begin
        filename = dlg = Qt::FileDialog::getOpenFileName(nil, "Choice File", "", "All files (*.*);;")
        input.setText(filename) if filename
      end
    }
    butt.setGeometry(0, 0, 23, 25)
    butt.move(360, 21 + 40 * i)
    return i, input
  end
  
  def is_valid?(input)
    flag = super
    if @not_null
      flag = (flag and (input.text =~ /\w+/)) # validare un path
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
