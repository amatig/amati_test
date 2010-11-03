require "rexml/document"

# Classe che rappresenta l'entita' npc.
# = Description
# Questa classe rappresenta l'entita' npc.
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

class Npc
  attr_reader :name, :descr, :place
  
  # Metodo di inizializzazione della classe.
  def initialize(name)
    file = File.new("data/#{name}.xml")
    doc = REXML::Document.new(file)
    root = doc.elements["npc"]
    @name = name.capitalize
    @descr = root.elements["descr"].text
    @place = Integer(root.elements["place"].text)
    file.close
  end
  
  # Ritorna una stringa che rappresenta il nome dell'npc.
  def to_s()
    return @name
  end
  
end
