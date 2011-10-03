# -*- coding: utf-8 -*-
class ProjectEnv
  include Singleton
  
  def initialize
    @node = {} # father static
    @setting = {}
    @application = {}
    @message = {}
    @variable = {}
    @restricted = {}
    @timeprofile = {}
    @dateprofile = {}
    @timedetail = {}
    @datedetail = {}
  end
  
  def clear
    @setting.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @application.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @variable.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @message.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @timedetail.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @datedetail.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @timeprofile.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
    @dateprofile.each do |k, v|
      del(v.class.to_s, v.node_id)
    end
  end
  
  def getProjectSettings
    return @setting
  end

  def getResourceTimeProfile
    temp = @timeprofile.map { |k, v| [v.name, "TimeProfile§§#{v.node_id}"] }
    return temp
  end
  
  def getResourceDateProfile
    temp = @dateprofile.map { |k, v| [v.name, "DateProfile§§#{v.node_id}"] }
    return temp
  end
  
  def getResourceWav
    temp = @message.map { |k, v| [v.name, "Message§#{@node[v.parent].node_id}§#{v.node_id}"] }
    return temp
  end

  def getResourceMessage
    temp = @message.map { |k, v| [v.file, v.filedeploy] }
    return temp
  end
  
  def getResourceAppVar
    temp = @variable.map { |k, v| [v.name, "ApplicationVariable§§#{v.node_id}"] }
    return temp
  end
  
  def getResourceResVar
    temp = @restricted.map { |k, v| [v.name, "ReservedVariable§§#{v.node_id}"] }
    return temp
  end
  
  # add father static
  def add_node(name, qtnode, parent_name)
    @node[name] = Node.new(qtnode, parent_name)
  end
  
  # esempio per caricare da xml
  def loadSettings(xmlNode)
    v = Setting.new
    v.name = "RemoteUser"
    v.node_id = v.name
    v.description = "Nome utente macchina remota"
    v.type = "STRING"
    v.value = xmlNode ? xmlNode.attributes["RemoteUser"] : ""
    add(v, "Project")
    
    v = Setting.new
    v.name = "RemotePasswd"
    v.node_id = v.name
    v.description = "Password utente macchina remota"
    v.type = "STRING"
    v.value = xmlNode ? xmlNode.attributes["RemotePasswd"] : ""
    add(v, "Project")
    
    v = Setting.new
    v.name = "RemoteIP"
    v.node_id = v.name
    v.description = "IP macchina remota"
    v.type = "STRING"
    v.value = xmlNode ? xmlNode.attributes["RemoteIP"] : ""
    add(v, "Project")

    v = Setting.new
    v.name = "ExportType"
    v.node_id = v.name
    v.description = "Tipologia di esportazione"
    v.type = "CHOICE"
    v.value = xmlNode ? xmlNode.attributes["ExportType"] : "/opt/build/etc/sipxpbx"
    add(v, "Project")
  end
  
  def load(xmlNode)
    loadSettings(xmlNode)
    
    apl = REXML::XPath.first(xmlNode, "ApplicationList")
    REXML::XPath.each(apl, "Application") do | var |
      t = Application.new(var)
      add(t, "ApplicationList")
    end
    avl = REXML::XPath.first(xmlNode, "ResouceList/VariableList/ApplicationVariableList")
    REXML::XPath.each(avl, "Variable") do | var |
      t = Variable.new(var)
      add(t, "ApplicationVariableList")
    end
    # start loading Messages
    mf = REXML::XPath.first(xmlNode, "ResouceList/MessageFolderList/MessageFolder")
    fold = @node["MessageFolder"]
    fold.node_id = mf.attributes["ID"]
    REXML::XPath.each(mf, "Message") do | message |
      t = Message.new(message)
      add(t, "MessageFolder")
    end
    # profile
    tpl = REXML::XPath.first(xmlNode, "ResouceList/TimeProfileList")
    REXML::XPath.each(tpl, "TimeProfile") do | var |
      t = TimeProfile.new(var)
      add(t, "TimeProfileList")
    end
    dpl = REXML::XPath.first(xmlNode, "ResouceList/DateProfileList")
    REXML::XPath.each(dpl, "DateProfile") do | var |
      t = DateProfile.new(var)
      add(t, "DateProfileList")
    end
    REXML::XPath.each(tpl, "TimeProfile") do |tpd|
      REXML::XPath.each(tpd, "TimeProfileDetail") do | var |
        t = TimeProfileDetail.new(var)
        add(t, tpd.attributes["Name"])
      end
    end
    REXML::XPath.each(dpl, "DateProfile") do |dpd|
      REXML::XPath.each(dpd, "DateProfileDetail") do | var |
        t = DateProfileDetail.new(var)
        add(t, dpd.attributes["Name"])
      end
    end
  end
  
  def serialize(rNode)
    rNode.attributes["RemoteUser"] = @setting["RemoteUser"].value
    rNode.attributes["RemotePasswd"] = @setting["RemotePasswd"].value
    rNode.attributes["RemoteIP"] = @setting["RemoteIP"].value
    rNode.attributes["ExportType"] = @setting["ExportType"].value
    # per ora salva solo i nodi della scena corrente nell'apposita applicazione
    # bisognerebbe ricaricare le altre app o cercare di serializzarla....
    al = REXML::XPath.first(rNode, "ApplicationList")
    @application.each do | key, value |
      ap = value.serialize(al)
      if MyGraphicsView.instance.current_application == key
        block = REXML::XPath.first(ap, "FlowBlocks")
        MyGraphicsView.instance.scene.items.each do |i|
          node = i.serialize()
          block.add_element node if node
        end
      end
    end
    
    rl = REXML::XPath.first(rNode, "ResouceList")
    vl = REXML::Element.new "VariableList"
    rl.add_element(vl)
    avl = REXML::Element.new "ApplicationVariableList"
    vl.add_element(avl)
    @variable.each do | key, value |
      value.serialize(avl)
    end
    rvl = REXML::Element.new "ReservedVariableList"
    vl.add_element(rvl)
    @restricted.each do | key, value |
      value.serialize(rvl)
    end
    tpl = REXML::Element.new "TimeProfileList"
    rl.add_element(tpl)
    @timeprofile.each do | key, value |
      ms = value.serialize(tpl)
      @timedetail.each do | key2, value2 |
        value2.serialize(ms) if (value2.parent == value.name)
      end
    end
    dpl = REXML::Element.new "DateProfileList"
    rl.add_element(dpl)
    @dateprofile.each do | key, value |
      ms = value.serialize(dpl)
      @datedetail.each do | key2, value2 |
        value2.serialize(ms) if (value2.parent == value.name)
      end
    end
    #starting from messages
    mfl = REXML::Element.new "MessageFolderList"
    rl.add_element(mfl)
    fold = @node["MessageFolder"]
    mf = REXML::Element.new "MessageFolder"
    mf.attributes["ID"] = fold.node_id
    mfl.add_element(mf)
    @message.each do | key, value |
      value.serialize(mf)
    end
  end
  
  def add(obj, parent_name)
    if obj.class.to_s == "DateProfile" or obj.class.to_s == "TimeProfile"
      @dateprofile.each do |key, value|
        return nil if value.name == obj.name
      end
      @timeprofile.each do |key, value|
        return nil if value.name == obj.name
      end
    end
    
    n = Qt::TreeWidgetItem.new
    n.setText(0, obj.name)
    n.setText(1, obj.node_id)
    n.setText(2, obj.class.to_s)
    n.setIcon(0, Qt::Icon.new("#{$abs_path}/images/#{obj.class.to_s}.ico"))
    obj.graph = n
    obj.parent = parent_name
    father = @node[parent_name].graph
    father.insertChild(father.childCount, n)
    case obj.class.to_s
    when "Setting"
      @setting[obj.node_id] = obj
    when "Application"
      @application[obj.node_id] = obj
    when "Variable"
      case parent_name
      when "ApplicationVariableList"
        @variable[obj.node_id] = obj
      when "ReservedVariableList"
        @restricted[obj.node_id] = obj
      end
    when "DateProfile"
      @dateprofile[obj.node_id] = obj
      add_node(obj.name, obj.graph, "DateProfileList")
    when "TimeProfile"
      @timeprofile[obj.node_id] = obj
      add_node(obj.name, obj.graph, "TimeProfileList")
    when "TimeProfileDetail"
      @timedetail[obj.node_id] = obj
    when "DateProfileDetail"
      @datedetail[obj.node_id] = obj
    when "Message"
      @message[obj.node_id] = obj
    end
    return n
  end
  
  def get(type, id)
    case type
    when "Setting"
      return @setting[id]
    when "Application"
      return @application[id]
    when "Variable"
      if @variable.key?(id)
        return @variable[id]
      elsif @restricted.key?(id)
        return nil
      else
        return nil
      end
    when "Message"
      return @message[id]
    when "TimeProfile"
      return @timeprofile[id]
    when "DateProfile"
      return @dateprofile[id]
    when "TimeProfileDetail"
      return @timedetail[id]
    when "DateProfileDetail"
      return @datedetail[id]
    else
      return nil
    end
  end
  
  def del(type, id)
    temp = nil
    case type
    when "Setting"
      temp = @setting.delete(id)
    when "Application"
      temp = @application.delete(id)
    when "Variable"
      if @variable.key?(id)
        temp = @variable.delete(id)
      end
    when "Message"
      temp = @message.delete(id)
    when "TimeProfileDetail"
      temp = @timedetail.delete(id)
    when "DateProfileDetail"
      temp = @datedetail.delete(id)
    when "TimeProfile"
      temp = @timeprofile.delete(id)
      @node.delete(temp.name) #si dovrebbe cancellare dai padri ma puo' cambiare nome non serve cmq
    when "DateProfile"
      temp = @dateprofile.delete(id)
      @node.delete(temp.name)
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

class Application < Node
  attr_accessor :name, :description
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
    end
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
           ]
  end
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    rNode.add_element ms
    ms.add_element REXML::Element.new "FlowBlocks"
    return ms
  end
  
end

class Variable < Node
  attr_accessor :name, :description, :type, :value

  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
      @type = "STRING"
      @value = ""
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
      @type = node.attributes["Type"]
      @value = node.attributes["DefaultValue"]
    end
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @type = fields[2].itemData(fields[2].currentIndex).toString
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
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    ms.attributes["Type"] = @type
    ms.attributes["DefaultValue"] = @value
    rNode.add_element ms
    return ms
  end
  
end

class Setting < Variable
  
  def set_fields(fields)
    @description = fields[0].toPlainText
    if @type == "CHOICE"
      @value = fields[1].itemData(fields[1].currentIndex).toString
    else
      @value = fields[1].text
    end
  end
  
  def get_fields
    if @type != "CHOICE"
      fields = [
                ["Description", @description, :memo],
                ["DefaultValue", @value, :text]
               ]
    else
      fields = [
                ["Description", @description, :memo],
                ["DefaultValue", @value, :type_con]
               ]
    end
    return fields
  end
  
end

class TimeProfile < Node
  attr_accessor :name, :description
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
    end
  end
    
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
           ]
  end
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    rNode.add_element ms
    return ms
  end
  
end

class DateProfile < TimeProfile
end

class Message < Node
  attr_accessor :name, :description, :file, :filedeploy
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
      @file = ""
      @filedeploy = ""
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
      @file = node.attributes["FileDefault"]
      refresh_deploy_path
    end
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @file = fields[2].text
    refresh_deploy_path
  end
  
  def refresh_deploy_path
    setting = SystemSettings.getConnectServer()
    if setting
      path = setting[3]
      if path =~ /remote\:/
        path = path.gsub("remote:", "")
        if path =~ /opt\/build/
          path = "#{path}/share/www/doc/message-ivr"
        else
          path = "/usr/share/www/doc/message-ivr"
        end
      else
        path = "#{path}/share/www/doc/message-ivr"
      end
      @filedeploy = path + "/" + Pathname.new(@file).basename
    else
      @filedeploy = ""
    end
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
    refresh_deploy_path
    ms.attributes["FileDeploy"] = @filedeploy

    #append languages here
    rNode.add_element ms
    return ms
  end
  
end

class TimeProfileDetail < Node
  attr_accessor :name, :description, :day, :from, :to
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
      @day = "LU"
      @from = "00:00:00"
      @to = "00:00:00"
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
      @day = node.attributes["Day"]
      @from = node.attributes["FromTime"]
      @to = node.attributes["ToTime"]
    end
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @day = fields[2].itemData(fields[2].currentIndex).toString
    @from = fields[3].time.toString
    @to = fields[4].time.toString
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
            ["Day", @day, :week],
            ["FromTime", @from, :time],
            ["ToTime", @to, :time],
           ]
  end
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    ms.attributes["Day"] = @day
    ms.attributes["FromTime"] = @from
    ms.attributes["ToTime"] = @to
    rNode.add_element ms
    return ms
  end
  
end

class DateProfileDetail < Node
  attr_accessor :name, :description, :day, :month
  
  def initialize(node=nil)
    super(nil, nil)
    if node==nil
      @name = ""
      @description = ""
      @sday = "1"
      @smonth = "1"
      @eday = "1"
      @emonth = "1"
    else
      @node_id = node.attributes["ID"]
      @name = node.attributes["Name"]
      @description = node.attributes["Description"]
      @sday = node.attributes["FromDay"]
      @smonth = node.attributes["FromMonth"]
      @eday = node.attributes["ToDay"]
      @emonth = node.attributes["ToMonth"]
    end
  end
  
  def set_fields(fields)
    @name = fields[0].text
    @description = fields[1].toPlainText
    @sday = fields[2].value.to_s
    @smonth = fields[3].itemData(fields[3].currentIndex).toString
    @eday = fields[4].value.to_s
    @emonth = fields[5].itemData(fields[5].currentIndex).toString
  end
  
  def get_fields
    return [
            ["Name", @name, :text],
            ["Description", @description, :memo],
            ["FromDay", @sday, :days],
            ["FromMonth", @smonth, :months],
            ["ToDay", @eday, :days],
            ["ToMonth", @emonth, :months],
           ]
  end
  
  def serialize(rNode)
    ms = REXML::Element.new self.class.to_s
    ms.attributes["ID"] = @node_id
    ms.attributes["Name"] = @name
    ms.attributes["Description"] = @description
    ms.attributes["FromDay"] = @sday
    ms.attributes["FromMonth"] = @smonth
    ms.attributes["ToDay"] = @eday
    ms.attributes["ToMonth"] = @emonth
    rNode.add_element ms
    return ms
  end
  
end
