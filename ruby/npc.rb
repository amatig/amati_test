require "rexml/document"

class Npc
  attr_accessor :name, :descr
  
  def initialize(name)
    file = File.new("npc/#{name}.xml")
    doc = REXML::Document.new(file)
    root = doc.elements["npc"]
    @name = name
    @descr = root.elements["descr"].text
    file.close
  end
  
  def to_s()
    return @name
  end
  
end
