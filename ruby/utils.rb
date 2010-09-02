# MESSAGGI

def list(array)
  str = array.join(", ")
  i = str.rindex(", ")
  str[i, 2] = " e " if i
  return str
end

def up_case(text)
  return text[0].chr.capitalize + text[1, text.size]
end

$_msg = {
  :benv => "%s a te %s! %s",
  :r_benv => "prima d'ogni cosa e' buona eduzione salutare!",
  :no_reg => "non ti conosco straniero, non sei nella mia storia!",
  :cnf_0 => "non ho capito...",
  :cnf_1 => "puoi ripetere?",
  :cnf_2 => "forse sbagli nella pronuncia?",
  :up_true => "ti sei alzato",
  :up_false => "sei gia' in piedi!",
  :down_true => "ti sei adagiato per terra",
  :down_false => "ti sei gia' per terra!",
  :c_e => "c'e'",
  :ci_sono => "ci sono",
  :uz => "nella zona %s %s",
  :nobody => "non c'e' nessuno",
  :nothing => "non c'e' nessun oggetto o persona corrispondente a quel nome qui!",
  :onlyu => "solo tu",
  :pl => "ti trovi %s, %s",
  :no_pl => "non conosco nessun luogo nelle vicinanze con questo nome!",
  :np => "sei nelle vicinanze %s",
}

def get_text(str)
  return $_msg[str.to_sym]
end

# FONT STYLE

def bold(text)
  return "" + text + ""
end

def uline(text)
  return "" + text + ""
end

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

def color(c, text)
  return $_color_set[c.to_sym] + text + ""
end

# GRAMMATICA

# articolo determinativo

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

#preposizioni articolate: di, a, da, in, con, su, per, tra, fra

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
