$_msg = {
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
  :gu => "nella zona",
  :pl => "ti trovi",
}

def say(str)
  return $_msg[str.to_sym]
end
