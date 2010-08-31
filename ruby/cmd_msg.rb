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
