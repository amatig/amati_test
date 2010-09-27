require "thread"

# = Description
# Classe che rappresenta l'entita' posto.
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
  attr_reader :id, :name, :descr, :attrs
  attr_accessor :near_place
  
  # Metodo di inizializzazione della classe.
  # [data] array contenete tutti i dati del posto.
  def initialize(data)
    @id, @name, @descr, @attrs = data
    @near_place = []
    @people_here = []
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  # Rimuove un oggeto di tipo User dalla lista delle persone in
  # questo posto.
  def remove_people(user)
    @mutex.synchronize { @people_here.slice!(@people_here.index(user)) }
  end
  
  # Aggiunge un oggeto di tipo User dalla lista delle persone in
  # questo posto.
  def add_people(user)
    @mutex.synchronize { @people_here << user }
  end
  
  # Ritorna l'array di tutti gli oggetti User (le persone) presenti nel posto.
  def people()
    @mutex.synchronize { return @people_here }
  end
  
  # Ritorna una stringa che rappresenta il nome del posto.
  def to_s()
    return @name
  end
  
end
