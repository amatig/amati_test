# -*- coding: utf-8 -*-
class ProjectEnv
  include Singleton
  
  def initialize
    @node = {} # father static
    @message = {}
    @variable = {}
    @restricted = {}
  end
  
  def clear
    @variable.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @restricted.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @message.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
  end
  
  def getResourceWav
    temp = @message.map { |k, v| [v.name, "Message§#{@node[v.parent].node_id}§#{v.node_id}"] }
    return temp
  end
  
  # add father static
  def add_node(name, qtnode, parent_name)
    @node[name] = Node.new(qtnode, parent_name)
  end
  
  # esempio per caricare da xml
  def load(xmlNode)
    # start loading Messages
    mf = REXML::XPath.first(xmlNode, "*/MessageFolder")
    fold = @node["MessageFolder"]
    fold.node_id = mf.attributes["ID"]
    REXML::XPath.each(mf, "Message") do | message |
      t = Message.new(message)
      add(t,"MessageFolder")
    end
  end
  
  def serialize(rNode)
    #starting from messages
    mfl = REXML::Element.new "MessagesFolderList"
    rNode.add_element(mfl)
    fold = @node["MessageFolder"]
    mf = REXML::Element.new "MessageFolder"
    mf.attributes["ID"] = fold.node_id
    mfl.add_element(mf)
    @message.each do | key, value |
      value.serialize(mf)
    end
  end
  
  def add(obj, parent_name)
    n = Qt::TreeWidgetItem.new
    n.setText(0, obj.name)
    n.setText(1, obj.node_id)
    n.setText(2, obj.class.to_s)
    n.setIcon(0, Qt::Icon.new("images/#{obj.class.to_s}.ico"))
    obj.graph = n
    obj.parent = parent_name
    father = @node[parent_name].graph
    father.insertChild(father.childCount, n)    
    case obj
    when Variable
      @variable[obj.node_id] = obj
    when Message
      @message[obj.node_id] = obj
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
  attr_accessor :node_id, :graph, :parent
  
  def initialize(qtnode, parent_name)
    @node_id = "#{Time.now.to_i}#{rand(10000000)}"
    @graph = qtnode
    @parent = parent_name
  end
  
end

class Variable < Node
  attr_accessor :name, :description, :type, :value
  
  def initialize
    super(nil, nil)
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
  attr_accessor :name, :description, :file
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
      @file = ""
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
      @file = node.attributes["FileDefault"]
    end
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
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    ms.attributes["FileDefault"] = @file
    #append languages here
    rNode.add_element ms
  end

end
