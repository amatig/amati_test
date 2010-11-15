require "rexml/document"
require "lib/database.rb"
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
    @db = Database.instance # singleton
    
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
    
    @count_wc = 0
    @count_gb = 0
    @count_eq = 0
    @count_ea = 0
    @dialog.keys.each do |k|
      @count_wc+=1 if k =~ /^welcome/
      @count_gb+=1 if k =~ /^goodbye/
      @count_eq+=1 if k =~ /^err_qst/
      @count_ea+=1 if k =~ /^err_aff/
    end
  end
  
  # Logica dell'npc, dell'interazione con l'utente.
  # @param [String] nick identificativo dell'utente.
  # @param [String] msg messaggio utente.
  # @return [String] messaggio npc.
  def parse(nick, msg)
    case msg
    when /^(ciao|salve)$/i
      return reply(nick, "welcome", @count_wc)
    when /^(arrivederci|addio|a\spresto|alla\sprossima|vado)$/i
      return reply(nick, "goodbye", @count_gb)
    when /(da\w?|ha\w?|sa\w?|conosc\w{1,3}|sapete|d\wre|dici|dite)\s(particolari|niente|qualcosa|cose|informazion\w|notizi\w|dettagl\w)\s(su\w{0,3}|d\w{0,4}|riguardo)\s([A-z\ ]+)\?/i
      return reply_info(nick, "quest", $4)
    else
      if msg.index("?") != nil
        return reply(nick, "err_qst", @count_eq)
      else
        return reply(nick, "err_aff", @count_ea)
      end
    end
  end
  
  # Rende variabile il messaggio dell'npc simulando un dialogo.
  # Usa il metodo "crave" per le decisioni.
  # @see Npc#crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [Integer] count numero di messaggi dell'npc per quel tipo.
  # @return [String] messaggio finale dell'npc.
  def reply(nick, type, count)
    crave(nick, type)
    return "%s: %s" % [bold(@name), @dialog["#{type}_#{rand count}"]]
  end
  
  # Ritorna nel informazioni che ha un npc rispetto ad un argomento
  # richiesto dall'utente. Usa il metodo "crave" per le decisioni.
  # @see Npc#crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [String] target oggetto di cui l'utente vuole informazioni.
  # @return [String] messaggio finale dell'npc.
  def reply_info(nick, type, target)
    crave(nick, type, target)
    # in caso ottenre info da db
    return "%s: %s" % [bold(@name), "Info su #{target}?"]
  end
  
  # Mette in cache nel database il tipo di richiesta dell'utente con
  # relativo timestamp e target, in maniera che si possa sapere se
  # un particolare tipo di richesta e' insistente su un tipo di argomento
  # da parte di un utente. Ne ottiene il valore attuale di insistenza e
  # confrontato con le logiche dell'npc decide se rispondere all'utente
  # o evitare la conversazione o altro.
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [String] target oggetto di cui l'utente vuole informazioni.
  # @return [Integer] decisione dell'npc.
  def crave(nick, type, target = "")
    @db.delete("npc_caches")
    @db.insert({
                 "user_nick" => nick,
                 "npc_name" => @name,
                 "type" => type,
                 "target" => target,
                 "timestamp" => Time.now.to_i
               }, 
               "npc_caches")
    return 0
  end
  
  # Identificativo dell'npc.
  # @return [String] identificativo dell'npc.
  def to_s()
    return @name
  end
  
  private :reply, :reply_info, :crave
end
