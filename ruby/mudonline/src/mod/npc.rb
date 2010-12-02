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
    @memory = Integer(root.elements["memory"].text)
    @max_quest = Integer(root.elements["max_quest"].text)
    @max_inter = Integer(root.elements["max_inter"].text)
    @likes = {}
    root.elements["likes"].each_element do |val|
      @likes[val.name] = val.text
    end
    @hates = {}
    root.elements["hates"].each_element do |val|
      @hates[val.name] = val.text
    end
    file.close
    
    # caricamento dei messaggi dell'npc
    localization("data/npcs/#{name}.xml", "npc")
  end
  
  # Logica dell'npc, dell'interazione con l'utente.
  # @param [String] nick identificativo dell'utente.
  # @param [String] msg messaggio utente.
  # @return [Array<Integer, String>] codice tipo e messaggio finale dell'npc.
  def parse(nick, msg)
    regex =  "(da\\w?|ha\\w?|sa\\w?|conosc\\w{1,3}|sapete|d\\w[rct]\\w{1,2}|qualche|alcun\\w)\\s"
    regex += "(particolar\\w|niente|qualcosa|info\\w*|notizi\\w|dettagl\\w{1,2})\\s"
    regex += "(su\\w{0,3}|d\\w{0,4}|riguardo)\\s([A-z\\ ]+)\\?"
    
    case msg
    when /^_start_18278374937_$/
      return reply_start(nick)
    when /^(ciao|salve)$/i
      return reply(nick, "welcome")
    when /^(arrivederci|addio|a\spresto|alla\sprossima|vado)$/i
      return reply(nick, "goodbye")
    when /#{regex}/i
      return reply_info(nick, "quest_info", $4)
    when /dove.+(e'|sta\w{0,2}|essere|trova\w{0,2})\s([A-z\\ ]+)\?/i
      return reply_info(nick, "quest_find", $2)
    else
      if msg.index("?") != nil
        return reply(nick, "err_qst")
      else
        return reply(nick, "err_aff")
      end
    end
  end
  
  # Comincia il dialogo con l'utente se e' disponibile.
  # @see Npc#is_free?
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @return [Array<Integer, String>] codice tipo e messaggio finale dell'npc.
  def reply_start(nick)
    if not is_free?(nick, "quest") # npc non disponibile
      return [0, bold(@name) + ": " + "Non ho tempo passa dopo!"] # mettere messaggio
    else
      return [1, bold(@name) + ": " + _("welcome")]
    end
  end
  
  # Rende variabile il messaggio dell'npc simulando un dialogo.
  # @see Npc#crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @return [Array<Integer, String>] codice tipo e messaggio finale dell'npc.
  def reply(nick, type)
    r = 1
    esito = ""
    if type == "goodbye"
      r = 0
    else
      esito = "crave_" if crave(nick, type)
    end
    return [r, bold(@name) + ": " + _("#{esito}#{type}")]
  end
  
  # Ritorna le informazioni che ha un npc rispetto ad un argomento
  # richiesto dall'utente.
  # @see Npc#crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [String] target oggetto di cui l'utente vuole informazioni.
  # @return [Array<Integer, String>] codice tipo e messaggio finale dell'npc.
  def reply_info(nick, type, target)
    t = type.split("_")
    msg = ""
    if not crave(nick, t[0], target)
      puts t[1]
      msg = "Info su #{target}?" # ottenre info da db
    else
      msg = _("crave_#{t[0]}")
    end
    return [2, bold(@name) + ": " + msg]
  end
  
  # Controlla la cache delle richieste in maniera che si possa sapere se
  # un particolare tipo di argomento e' insistente da parte di un utente.
  # Ne ottiene dei valori che accoppiati con le le logiche dell'npc servono 
  # a decidere come rispondere all'utente.
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [String] target oggetto di cui l'utente vuole informazioni.
  # @return [Array<Boolean>] valori di decisione dell'npc.
  def check_crave(nick, type, target = "")
    @db.delete("npc_caches", "#{Time.now.to_i}-timestamp>#{@memory}")
    c1 = @db.read("type,target",
                  "npc_caches",
                  "user_nick='#{nick}' and npc_name='#{@name}'")
    c2 = @db.read("type,target",
                  "npc_caches",
                  "user_nick='#{nick}' and npc_name='#{@name}' and type='#{type}' and target='#{target}'")
    # puts "#{type} #{c2.length}"
    
    i = @max_quest # - c2.length??
    now = mud_time.hour
    ls = le = hs = he = 0
    begin
      ls, le = @likes["timerange"].split("-")
      i += Integer(@likes["value"]) if (Integer(ls) <= now and now < Integer(le))
    rescue
    end
    begin
      hs, he = @hates["timerange"].split("-")
      i -= Integer(@hates["value"]) if (Integer(hs) <= now and now < Integer(he))
    rescue
    end
    if @likes.has_key?("weather")
      i += Integer(@likes["value"]) if Integer(@likes["weather"]) == 2
    end
    if @hates.has_key?("weather")
      i -= Integer(@hates["value"]) if Integer(@hates["weather"]) == 2
    end
    
    bonta = false
    if i > 1
      bonta = rand(i) <= Integer(i * 2 / 3)
    end
    
    n = @max_inter - c1.length + 1
    n = 1 if n <= 0 # se per errori imprevisti la cache supera il max
    disponibilita = rand(n) > 0 # rende + casuale la risposta
    
    return [disponibilita, bonta]
  end
  
  # Tramite i valori di decisione ottenuti dai dati in possesso dell'npc,
  # stabilisce se rispondere o no ad una richiesta dell'utente.
  # Nel caso di risposta manda in cache la richiesta.
  # @see Npc#check_crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @param [String] target oggetto di cui l'utente vuole informazioni.
  # @return [Boolean] decisione dell'npc.  
  def crave(nick, type, target = "")
    d, b = check_crave(nick, type, target)
    if (d)
      puts "ok"
      @db.insert({
                   "user_nick" => nick,
                   "npc_name" => @name,
                   "type" => type,
                   "target" => target,
                   "timestamp" => Time.now.to_i
                 }, 
                 "npc_caches")
      return false
    else
      return true
    end
  end
  
  # Tramite i valori di decisione ottenuti dai dati in possesso dell'npc,
  # stabilisce se un npc e' disponibile per il dialogo.
  # @see Npc#check_crave
  # @param [String] nick identificativo dell'utente.
  # @param [String] type tipo di messaggio.
  # @return [Boolean] decisione dell'npc.  
  def is_free?(nick, type)
    d, b = check_crave(nick, type)
    return d
  end
  
  # Identificativo dell'npc.
  # @return [String] identificativo dell'npc.
  def to_s()
    return @name
  end
  
  private :reply_start, :reply, :reply_info, :check_crave, :crave, :is_free?
end
