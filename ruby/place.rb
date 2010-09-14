require "thread"

class Place
  attr_accessor :id, :name, :descr, :attrs, :near_place
  
  def initialize(data)
    # init dati place
    @id, @name, @descr, @attrs = data
    @near_place = []
    @people_here = []
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def add_near_place(place)
    @near_place << place # non sono mai modificati
  end
  
  def remove_people(user)
    @mutex.synchronize { @people_here.slice!(@people_here.index(user)) }
  end
  
  def add_people(user)
    @mutex.synchronize { @people_here << user }
  end
  
  def people()
    @mutex.synchronize { return @people_here }
  end
  
  def to_s()
    return @name
  end
  
end
