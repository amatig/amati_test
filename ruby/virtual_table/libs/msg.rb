class Msg
  attr_accessor :type, :id, :action, :args, :data
  
  def self.dump(args = {})
    m = Msg.new
    m.type = args[:type]
    m.id = args[:id]
    m.action = args[:action]
    m.args = args[:args]
    m.data = args[:data]
    return Marshal.dump(m)
  end
  
  def self.load(data)
    return Marshal.load(data)
  end
  
end
