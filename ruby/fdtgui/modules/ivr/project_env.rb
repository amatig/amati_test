class ProjectEnv
  include Singleton
  
  def initialize
    @node = {} # father static
    
    @message = {}
    @variable = {}
    @restricted = {}
  end
  
  # add father static
  def add_node(name, qtnode, parent_name)
    @node[name] = Node.new(qtnode, parent_name)
  end
  
  # esempio per caricare da xml
  
  # def add_variable(id, name, description, type, value)
  #   temp = Variable.new
  #   temp.id = id
  #   temp.name = name
  #   temp.description = description
  #   temp.type = type
  #   temp.value = value
  #   add(temp, ApplicationVariableList)
  # end
  
  def add(obj, parent_name)
    n = Qt::TreeWidgetItem.new
    n.setText(0, obj.name)
    n.setText(1, obj.id)
    n.setText(2, obj.class.to_s)
    n.setIcon(0, Qt::Icon.new("images/#{obj.class.to_s}.ico"))
    obj.graph = n
    obj.parent = parent_name
    father = @node[parent_name].graph
    father.insertChild(father.childCount, n)    
    case obj
    when Variable
      @variable[obj.id] = obj
    when Message
      @message[obj.id] = obj
    end
  end
  
  def get(type, id)
    case type
    when "Variable"
      return @variable[id]
    when "Message"
      return @message[id]
    else
      return nil
    end
  end
  
  def del(type, id)
    temp = nil
    case type
    when "Variable"
      temp = @variable.delete(id)
    when "Message"
      temp = @message.delete(id)
    end
    @node[temp.parent].graph.removeChild(temp.graph) if temp
  end
  
end

class Node
  attr_accessor :graph, :parent
  
  def initialize(qtnode, parent_name)
    @graph = qtnode
    @parent = parent_name
  end
  
end

class Variable < Node
  attr_accessor :id, :name, :description, :type, :value
  
  def initialize
    @id = (rand 10000000).to_s
    @name = ""
    @description = ""
    @type = "STRING"
    @value = ""
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @type = fields[2].itemData(fields[2].currentIndex).toInt
    @value = fields[3].text
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
            ["Type", @type, :type],
            ["DefaultValue", @value, :text]
           ]
  end
  
end

class Message < Node
  attr_accessor :id, :name, :description, :file
  
  def initialize
    @id = (rand 10000000).to_s
    @name = ""
    @description = ""
    @file = ""
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @file = fields[2].text
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
            ["FileDefault", @file, :wav]
           ]
  end
  
end
