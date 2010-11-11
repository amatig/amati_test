require "rexml/document"
require "lib/utils.rb"

# Classe per la gestione degli NPC (Non-Player Character).
# = Description
# Questa classe rappresenta l'entita' npc, personaggio non giocante del mud.
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
  include Utils
  
  # Identificativo dell'npc.
  # @return [String] identificativo dell'npc.
  attr_reader :name
  # Descrizione dell'npc.
  # @return [String] descrizione dell'npc.
  attr_reader :descr
  # Indice del posto in cui e' l'npc.
  # @return [Integer] indice del posto in cui e' l'npc.
  attr_reader :place
  
  # Una nuova istanza di Npc.
  def initialize(name)
    file = File.new("data/npcs/#{name}.xml")
    doc = REXML::Document.new(file)
    root = doc.elements["npc"]
    @name = name.capitalize
    @descr = root.elements["descr"].text
    @place = Integer(root.elements["place"].text)
    @dialog = {}
    root.elements["dialog"].each_element do |val|
      @dialog[val.name] = val.text
    end
    file.close
  end
  
  # Logica dell'npc, dell'interazione con l'utente.
  # @param [String] nick identificativo dell'utente.
  # @param [String] msg messaggio utente.
  # @return [String] messaggio npc.
  def parse(nick, msg)
    case msg
    when /^(ciao|salve)$/i
      return context("Saaaalve straniero...")
    when /^(arrivederci|addio|a\spresto|alla\sprossima|vado)$/i
      return context("Alla prossima straniero!")
    when /(da\w?|ha\w?|sa\w?|conosc\w|sapete|conoscete|d\wre|dici|dite)\s(particolari|niente|qualcosa|cose|informazion\w|notizi\w|dettagl\w)\s(su\w{0,3}|d\w{0,4}|riguardo)\s([A-z\ ]+)/i
      return context("Informazioni su #{$4}?")
    else
      return context(@dialog["dnf_#{rand 2}"])
    end
  end
  
  # Aggiunge al messaggio dell'npc il nome davanti al testo, tipo dialogo.
  # @param [String] msg messaggio grezzo.
  # @return [String] messaggio con il nome dell'npc.
  def context(msg)
    return "%s: %s" % [bold(@name), msg]
  end
  
  # Identificativo dell'npc.
  # @return [String] identificativo dell'npc.
  def to_s()
    return @name
  end
  
  private :context
end
