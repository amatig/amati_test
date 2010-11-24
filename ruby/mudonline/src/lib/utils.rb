# Insieme di utilities.
# = Description
# Modulo contente una serie di utilities di vario genere.
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

module Utils
  
  # Data e ora del mondo del mud. 1 secondo reale sono 4 secondi nel mud, 
  # quindi 1 ora reale sono 4 ore nel mud, 1 giorno reale 4 giorni nel mud.
  def mud_time()
    start_time = 1290521959 # inizio del gioco timestamp
    delta = Time.now.to_i - start_time
    return Time.at(start_time + (delta * 4))
  end
  
  # Carica i messaggi di una entita' in base alla lingua desiderata.
  # La funzione inizializza delle variabili di istanza all'interno 
  # dell'entita' che include questo modulo.
  # @param [String] filename percorso completo del file xml dell'entita'.
  # @param [String] context nodo principale dell'entita'.
  # @param [String] lang lingua desiderata.
  def localization(filename, context, lang = "italian")
    file = File.new(filename)
    doc = REXML::Document.new(file)
    root = doc.elements[context]
    
    @_msgs = {}
    @_counts = {}
    root.elements["lang"].elements[lang].each_element do |val|
      if val.name =~ /^(\w+)\_\d+$/
        @_msgs[val.name] = val.text
        @_counts[$1] = 0
      end
    end
    file.close
    
    @_msgs.keys.each do |k|
      @_counts[$1] += 1 if k =~ /^(\w+)\_\d+$/
    end
  end
  
  # Ritorna un messaggio rappresentate una risposta o affermazione del bot.
  # Usa attributi di instanza che devono essere al momento dell'utilizzo, 
  # queste variabili vengono inizializzate con la funzione localization.
  # @see Utils#localization
  # @param [String, Symbol] label etichetta' che identifica il messaggio.
  # @return [String] messaggio del mud per l'utente.
  def _(label)
    label = label.to_s
    c = (@_counts[label] > 1) ? rand(@_counts[label]) : 0
    temp = @_msgs["#{label}_#{c}"]
    if (not temp and @log)
      @log.error("Messaggio '#{label}_#{c}' inesistente")
    end
    return temp
  end
  
  # Concatena tramite virgole gli elemeneti di un array.
  # L'ultimo elemento viene concatenato per 'e'.
  # @example
  #   conc ( [ "mario" , "carlo" , "fabio" ] ) # => "mario, carlo e fabio"
  # @param [Array<Scalar>] elems array di elementi (scalari).
  # @return [String] concatenazione degli elementi.
  def conc(elems)
    l = elems[0..-2]
    if l.length >= 1
      return "%s e %s" % [l.join(", "), elems[-1]]
    else
      return elems[0]
    end
  end
  
  # Rende maiuscola la prima lettera di una parola senza modificarne le altre.
  # @param [String] text parola originale.
  # @return [String] parola con la prima lettera in maiuscolo.
  def up_case(text)
    return text[0].chr.capitalize + text[1, text.size]
  end
  
  # Aggiunge ad una parola i tag stile bold (per il client irc).
  # @param [String] text parola originale.
  # @return [String] parola taggata.
  def bold(text)
    return "" + text + ""
  end
  
  # Aggiunge ad una parola i tag stile underline (per il client irc).
  # @param [String] text parola originale.
  # @return [String] parola taggata.
  def uline(text)
    return "" + text + ""
  end
  
  # Aggiunge ad una parola i tag stile italic (per il client irc).
  # @param [String] text parola originale.
  # @return [String] parola taggata.
  def italic(text)
    return "" + text + ""
  end
  
  COLOR_SET = {
    :black => "1",
    :navy_blue => "2",
    :green => "3",
    :red => "4",
    :brown => "5",
    :purple => "6",
    :olive => "7",
    :yellow => "8",
    :lime_green => "9",
    :teal => "10",
    :aqua_light => "11",
    :royal_blue => "12",
    :hot_pink => "13",
    :dark_gray => "14",
    :light_gray => "15",
    :white => "16",
  }
  
  # Aggiunge ad una parola i tag di un colore (per il client irc).
  #
  # Codici colore:
  #   :black
  #   :navy_blue
  #   :green
  #   :red
  #   :brown
  #   :purple
  #   :olive
  #   :yellow
  #   :lime_green
  #   :teal
  #   :aqua_light
  #   :royal_blue
  #   :hot_pink
  #   :dark_gray
  #   :light_gray
  #   :white
  #
  # @example
  #   color ( :black , "ciao" )
  #   color ( "black" , "ciao" )
  #
  # @param [Symbol, String] ccolor codice colore.
  # @param [String] text parola originale.
  # @return [String] parola taggata.
  def color(ccolor, text)
    return COLOR_SET[ccolor.to_sym] + text + ""
  end
  
  # Stabilisce l'articolo determinativo di un parola.
  #
  # Codice tipo:
  #
  #   1 #=> Maschile singolare
  #   2 #=> Maschile plurale
  #   3 #=> Femminile singolare
  #   4 #=> Femminile plurale
  # @param [Integer] ctype codice tipo.
  # @param [String] text parola.
  # @return [String] articolo determinativo.
  def a_d(ctype, text)
    con = %W{ b c d f g h j k l m n p q r s t v w x y z }
    voc = %W{ a e i o u }  
    # 1 maschile singolare e 2 plurale
    # 3 femminile singolare e 4 plurale
    case Integer(ctype)
    when 1
      if text =~ /^(z|pn|gn|ps|x|y)/i
        return "lo "
      elsif text =~ /^s(.)/i and (con.include? $1.downcase)
        return "lo "
      elsif (voc.include? text[0,1].downcase)
        return (text !~ /^(io|ie)/i) ? "l'" : "lo "
      elsif text =~ /^h(.)/i and (voc.include? $1.downcase)
        return "l'"
      else
        return "il "
      end
    when 2
      return "gli " if text.downcase == "dei" # eccezione
      if text =~ /^(z|pn|gn|ps|x|y)/i
        return "gli "
      elsif text =~ /^s(.)/i and (con.include? $1.downcase)
        return "gli "
      elsif (voc.include? text[0,1].downcase)
        return "gli "
      elsif text =~ /^h(.)/i and (voc.include? $1.downcase)
        return "gli "
      else
        return "i "
      end
    when 3
      if (voc.include? text[0,1].downcase) and text !~ /^(io|ie)/i
        return "l'"
      elsif text =~ /^h(.)/i and (voc.include? $1.downcase)
        return "l'"
      else
        return "la "
      end
    when 4
      return (text[0,1].downcase == "e") ? "l'" : "le "
    end
  end
  
  # Stabilisce la preposizioni articolata 'di' di un articolo determinativo.
  # @param [String] art articolo determinativo.
  # @return [String] preposizione articolata 'di'.
  def pa_di(art)
    case art
    when "il "
      return "del "
    when "lo "
      return "dello "
    when "la "
      return "della "
    when "gli "
      return "degli "
    when "i "
      return "dei "
    when "le "
      return "delle "
    when "l'"
      return "dell'"
    end
  end
  
  # Stabilisce la preposizioni articolata 'in' di un articolo determinativo.
  # @param [String] art articolo determinativo.
  # @return [String] preposizione articolata 'in'.
  def pa_in(art)
    case art
    when "il "
      return "nel "
    when "lo "
      return "nello "
    when "la "
      return "nella "
    when "gli "
      return "negli "
    when "i "
      return "nei "
    when "le "
      return "nelle "
    when "l'"
      return "nell'"
    end
  end
  
end
