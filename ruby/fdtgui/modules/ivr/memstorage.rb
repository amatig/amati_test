class MemStorage
  
  def initialize()
    @linear = {}
    @grouped = {}
    @grouped["Ungrouped"] = Ungrouped.new
  end
  
  def key?(key)
    return @linear.key?(key)
  end
  
  def [](key)
    return @linear[key]
  end
  
  def []=(key, value)
    if @linear.key?(key)
      @linear[key].value = value
    else
      raise KeyError, "you must add a key before manage it"
    end
  end
  
  def add_group(name, type)
    const = Kernel.const_get(type.capitalize)
    @grouped[name.capitalize] = const.new
  end
  
  def get_group(name)
    return @grouped[name]
  end
  
  def each
    @linear.each { |item| yield item }
  end
  
  def groups
    return @grouped.each
  end
  
  def add_entity(key, type, not_null = false, value = nil, group = nil)
    if not @linear.key?(key)
      begin
        const = Kernel.const_get(type.capitalize)
        elem = const.new(value, not_null)
      rescue Exception => e
        raise TypeError, "Unsupported type: #{type.capitalize} - details: #{e}"
      end
      group = "Ungrouped" if (group == nil)
      unless @grouped.key?(group.capitalize)
        raise TypeError, "Unsupported group: #{group.capitalize}"
      end
      @grouped[group.capitalize][key] = elem
      @linear[key] = elem
    end
  end
  
end
