require "singleton"

class Env
  include Singleton
  attr_accessor :table, :objects, :hash_objects
  
  def initialize
    @table = nil
    @objects = [] # lista oggetti sul tavolo
    @hash_objects = {} # per accedere agli oggetti + velocemente
    @hand = nil
  end
  
  def add_table(o)
    @table = o
    return o
  end
  
  def add_object(o)
    @objects << o
    @hash_objects[o.oid] = o
    return o
  end
  
  def add_hand(o)
    @hand = o
    return o
  end
  
  def get_hand
    return @hand
  end
  
  def add_first_object(o)
    @objects.insert(0, o)
    @hash_objects[o.oid] = o
    return o
  end
  
  def del_object(o)
    @objects.delete(o)
    @hash_objects.delete(o.oid)
    return o
  end
  
  def del_object_by_id(oid)
    o = get_object(oid)
    del_object(o)
    return o
  end
  
  def del_all_card
    @hash_objects.keys.each do |oid|
      o = get_object(oid)
      del_object(o) if o.kind_of?(Card)
    end
  end
  
  def to_front(o)
    @objects.delete(o)
    @objects.push(o)
  end
  
  def get_object(oid)
    return @hash_objects[oid]
  end
  
end
