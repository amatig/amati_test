require "thread"

# Entita' Place.
# = Description
# Questa classe rappresenta l'entita' posto, un luogo del mondo del mud.
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
  # Indice del posto.
  # @return [Integer] indice del posto.
  attr_reader :id
  # Identificativo del posto.
  # @return [String] identificativo del posto.
  attr_reader :name
  # Descrizione del posto.
  # @return [String] descrizione del posto.
  attr_reader :descr
  # Rappresenta se un posto e' maschile/femminile singolare/plurale,
  # serve per poterne identificare l'articolo.
  # @return [Integer] attributo per identificare l'articolo.
  attr_reader :attrs
  # Lista dei posti adiacenti.
  # @return [Array<Place>] lista dei posti adiacenti.
  attr_reader :near_place
  
  # Una nuova istanza di Place.
  # @param [Array<String>] data contiene tutti i dati del posto.
  def initialize(data)
    @id = Integer(data[0])
    @name = data[1]
    @descr = data[2]
    @attrs = Integer(data[3])
    @near_place = []
    @people_here = []
    
    @init_np = false # fa fare l'init_near_place una sola volta
    
    @mutex = Mutex.new
  end
  
  # Aggiunge a questo luogo le istanze dei posti vicini.
  # Il flag init_np serve ad assicurarsi che l'aggiunta possa essere 
  # fatta una sola volta.
  def init_near_place(place_instances, near_places)
    unless @init_np
      near_places.each do |near|
        near_place << place_instances[Integer(near[0])]
      end
      @init_np = true
    end
  end
  
  # Rimuove un utente o npc dalla lista delle persone in questo posto.
  def remove_people(p)
    @mutex.synchronize { @people_here.delete(p) if @people_here.include?(p) }
  end
  
  # Aggiunge un utente o npc dalla lista delle persone in questo posto.
  def add_people(p)
    @mutex.synchronize { @people_here << p unless @people_here.include?(p) }
  end
  
  # Ritorna l'array di tutti le persone presenti nel posto.
  def get_people()
    @mutex.synchronize { return @people_here }
  end
  
  # Ritorna una stringa che rappresenta il nome del posto.
  def to_s()
    return @name
  end
  
end
