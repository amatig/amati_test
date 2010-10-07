# = Description
# Insieme di utilities.
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
  
  # Ritorna una stringa, concatenando tramite virgole gli elemeneti di un array.
  # L'ultimo elemento viene concatenato per 'e'.
  #
  # [es.] list ( [ "mario", "carlo", "fabio" ] ) #=> "mario, carlo e fabio"
  def list(array)
    str = array.join(", ")
    i = str.rindex(", ")
    str[i, 2] = " e " if i
    return str
  end
  
  # Ritorna una stringa con la prima lettera maiuscola.
  def up_case(text)
    return text[0].chr.capitalize + text[1, text.size]
  end
  
  # Ritorna una stringa con lo stile bold (per il client irc).
  def bold(text)
    return "" + text + ""
  end
  
  # Ritorna una stringa con lo stile underline (per il client irc).
  def uline(text)
    return "" + text + ""
  end
  
  # Ritorna una stringa con lo stile italic (per il client irc).
  def italic(text)
    return "" + text + ""
  end
  
  $_color_set = {
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
  
  # Ritorna una stringa con i codici colore (per il client irc).
  # L'argomento <em>c</em> e' un symbol/stringa per ottenere il colore
  # dall'insieme indicizzato dei colori disponibili.
  #
  # Valori possibili di <em>c</em>:
  # * black
  # * navy_blue
  # * green
  # * red
  # * brown
  # * purple
  # * olive
  # * yellow
  # * lime_green
  # * teal
  # * aqua_light
  # * royal_blue
  # * hot_pink
  # * dark_gray
  # * light_gray
  # * white
  def color(c, text)
    return $_color_set[c.to_sym] + text + ""
  end
  
  # Ritorna una stringa rappresentante l'articolo determinativo
  # della parola nell'argomento <em>text</em>, l'argomento 
  # <em>type</em> invece e' un intero che rapprensenta il tipo di parola:
  #
  # 1. Maschile singolare
  # 2. Maschile plurale
  # 3. Femminile singolare
  # 4. Femminile plurale
  def a_d(type, text)
    con = %W{ b c d f g h j k l m n p q r s t v w x y z }
    voc = %W{ a e i o u }  
    # 1 maschile singolare e 2 plurale
    # 3 femminile singolare e 4 plurale
    case Integer(type)
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
  
  # Ritorna una stringa rappresentante la preposizioni articolata 'di' 
  # partendo dall'articolo determinativo passato nell'argomento <em>art</em>.
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
  
  # Ritorna una stringa rappresentante la preposizioni articolata 'in' 
  # partendo dall'articolo determinativo passato nell'argomento <em>art</em>.
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
