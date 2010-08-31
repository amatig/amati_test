def art_det(type, text)
  con = %W{ b c d f g h j k l m n p q r s t v w x y z }
  voc = %W{ a e i o u }
  case type
  when 1
    if text =~ /^(z|pn|gn|ps|x|y)/i
      return "lo " + text
    elsif text =~ /^s(.)/i and (con.include? $1)
      return "lo " + text
    elsif (voc.include? text[0,1])
      return "l'" + text
    elsif text =~ /^h(.)/i and (voc.include? $1)
      return "l'" + text
    else
      return "il " + text
    end
  when 2
    if text =~ /^(z|pn|gn|ps|x|y)/i
      return "gli " + text
    elsif text =~ /^s(.)/i and (con.include? $1)
      return "gli " + text
    elsif (voc.include? text[0,1])
      return "gli " + text
    elsif text =~ /^h(.)/i and (voc.include? $1)
      return "gli " + text
    else
      return "i " + text
    end
  when 3
    if (voc.include? text[0,1])
      return "l'" + text
    elsif text =~ /^h(.)/i and (voc.include? $1)
      return "l'" + text
    else
      return "la " + text
    end
  when 4
    if text[0,1] == "e"
      return "l'" + text
    else
      return "le " + text
    end
  end
end

def say(str)
  msg = {
    :benv => "%s a te %s",
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
    :nel_1 => "nel",
    :nel_2 => "nella",
    :nel_3 => "nelle",
    :art_1 => "il",
    :art_2 => "la",
    :art_3 => "le",
    :gu => "nella zona",
    :pl => "ti trovi",
    :near => "nelle vicinanze",
  }
  return msg[str.to_sym]
end

def bold(text)
  return "" + text + ""
end

def uline(text)
  return "" + text + ""
end

def italic(text)
  return "" + text + ""
end

def color(c, text)
  color_set = {
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
  return color_set[c.to_sym] + text + ""
end
