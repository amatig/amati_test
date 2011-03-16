class FdtNode
  attr_accessor :memstorage
  attr_reader :id, :type, :childs, :edgeList
  
  def self.getInstance(type)
    f = new(generate_id, type)
    f.internal_setGraphInfo
    f.internal_fixPosChilds
    return f
  end
  
  def self.loadInstance(xmlnode)
    id = xmlnode.attributes["ID"]
    type = xmlnode.attributes["Type"]
    f = new(id, type.downcase)
    clip = ClipBoard.instance
    f.memstorage.each do | key, value |
      f.memstorage[key] = xmlnode.attributes[key]
    end
    f.internal_checkChilds
    
    f.internal_setGraphInfo(xmlnode.attributes["Top"].to_i,
                            xmlnode.attributes["Left"].to_i)
    
    REXML::XPath.each(xmlnode, "*/Connector") do |conn|
      unless f.childs.key?(conn.attributes["ID"])
        f.memstorage[conn.attributes["ID"]] = true
        f.checkChild(conn.attributes["ID"])
      end
      if conn.attributes["NextBlock"] != ""
        ch = f.childs[conn.attributes["ID"]]
        clip.add_to([ch, conn.attributes["NextBlock"]])
      end
    end
    f.internal_fixPosChilds
    return f
  end
  
  def self.createInstance(type)    
    f = new(generate_id, type)
    if f.inputDialog
      f.internal_setGraphInfo
      f.internal_fixPosChilds
    end
    return f
  end
  
  # unique id
  def self.generate_id()
    return "#{Time.now.to_i}#{rand(10000000)}"
  end
  
  def initialize(id, type)
    super()
    @id = id
    @type = type
    @childs = {} # instanze di nodi
    @edgeList = []
    load_metadata
  end
  
  def load_metadata()
    @memstorage = MemStorage.new
    @memstorage.add_entity("Name", "Text", true)
    @memstorage.add_entity("Description", "Memo", false)
    
    file = File.new "modules/ivr/types/#{@type.downcase}.xml"
    doc = REXML::Document.new(file)
    
    @type = REXML::XPath.first(doc, "//type").text
    descr = REXML::XPath.first(doc, "//description")
    @memstorage["Description"] = descr.text if descr
    @raw_image = REXML::XPath.first(doc, "//style//image").text
    @width = Integer(REXML::XPath.first(doc, "//style//width").text)
    @height = Integer(REXML::XPath.first(doc, "//style//height").text)
    @line_mode = REXML::XPath.first(doc, "//properties//edges").text
    REXML::XPath.each(doc, "//edit/*") do |e|
      if e.name == "attr"
        @memstorage.add_entity(e.attributes["name"], 
                               e.attributes["type"], 
                               e.attributes["not_null"] == "true",
                               e.attributes["value"])
      else
        @memstorage.add_group(e.attributes["name"], 
                              e.attributes["type"])
      end
    end
    @raw_childs = {} # supporto per la creazione dei figli
    REXML::XPath.each(doc, "//connections//connector") do |c|
      @raw_childs[c.attributes["type"]] = [c.attributes["optional"] != "true",
                                           c.attributes["index"].to_i,
                                           c.attributes["color"]]
      if c.attributes["optional"] == "true"
        if c.attributes["group"]
          @memstorage.add_entity(c.attributes["type"], 
                                 "Connector", 
                                 c.attributes["not_null"] == "true", 
                                 false, 
                                 c.attributes["group"])
        else
          @memstorage.add_entity(c.attributes["type"], 
                                 "Connector", 
                                 c.attributes["not_null"] == "true")
        end
      end
    end
    if @raw_childs.length > 0
      @memstorage.add_entity("Layout", "Choice", 
                             false, 
                             [["Bottom", "0"], ["Left", "1"], ["Top", "2"], ["Right", "3"]])
    end
    # fix nome di base
    if (@type == "Begin" or @type == "End")
      @memstorage["Name"] = @type
    end
    file.close
  end
  
  def serialize()
    node = REXML::Element.new "Block"
    node.attributes["Type"] = @type.upcase
    node.attributes["Top"] = x.to_i
    node.attributes["Left"] = y.to_i
    node.attributes["ID"] = @id
    node.attributes["Name"] = @memstorage["Name"].value
    begin
      node.attributes["Description"] = @memstorage["Description"].value
    rescue
      node.attributes["Description"] = ""
    end
    @memstorage.each do | key, value |
      begin
        node.attributes[key] = @memstorage[key].value
      rescue
        node.attributes[key] = ""
      end
    end
    stats = REXML::Element.new "Statistics"
    node.add(stats)
    conns = REXML::Element.new "Connections"
    node.add(conns)
    @childs.each do | name, value |
      if value.edgeList.size <= 1
        tmp = REXML::Element.new "Connector"
        tmp.attributes["ID"] = name
        begin
          tmp.attributes["NextBlock"] = value.edgeList[0].destNode.id
        rescue
          tmp.attributes["NextBlock"] = ""
        end
        tmp.attributes["index"] = value.index
        conns.add(tmp)
      end
    end
    return node
  end
  
  def method_missing(name, *args, &block)
    m = "internal_#{name}"
    if methods.grep(m).size != 0
      puts "Deprecated Method #{name} use: #{m}"
      send(m, *args, &block)
    else
      super
    end
  end
  
  private_class_method :new, :generate_id
  private :load_metadata
  
end

class FdtChildNode < FdtNode
  
  def self.getInstance(type, index, color)
    f = new(generate_id, "Child")
    f.raw_image = type
    f.index = index
    f.color = color ? color : "#000"
    f.internal_setGraphInfo
    return f
  end
  
  def load_metadata()
    @memstorage = MemStorage.new
    @memstorage.add_entity("Name", "Text", false)
    
    @raw_image = "Child"
    @width = 25
    @height = 25
    @line_mode = "one"
    @raw_childs = {} # supporto temp con le label dei figli
  end
  
  def serialize()
  end
  
end
