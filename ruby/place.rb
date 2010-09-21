require "thread"

# = Description
# ...
# = License
# Nemesis - IRC Mud Multiplayer Online totalmente italiano
#
# Copyright (C) 2010 Giovanni Amati
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
# = Authors
# Giovanni Amati

class Place
  attr_reader :id, :name, :descr, :attrs, :near_place
  
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
