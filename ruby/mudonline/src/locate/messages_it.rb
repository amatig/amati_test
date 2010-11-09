# Messaggi in lingua italiana.
# = Description
# Questo modulo implementa una get_text rivisitata per utilizzare varie lingue, in questo caso italiano.
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

module GetText
  
  MSG_SET = {
    :test => "Salve %s, contattami in privato",
    :benv => "Oooh %s a te %s! Da quanto tempo! %s",
    :r_benv => "Prima d'ogni cosa e' buona eduzione salutare!",
    :no_reg => "Non ti conosco straniero, non sei nella mia storia!",
    :nothing => "Mmm %s? Non c'e' nessun oggetto o persona corrispondente a quel nome qui!",
    :no_pl => "Mmm %s? Non conosco nessun luogo nelle vicinanze con questo nome!",
    :pl => "Ti trovi %s, %s",
    :new_pl => "Sei giunto %s, %s",
    :np => "Sei nelle vicinanze %s",
    :uz => "Nella zona %s %s",
    :desc_npc => "Che dire di %s... %s",
    :desc_people => "E' un giocatore della storia come te.",
    :logout => "Terro' presente il punto in cui la storia e' arrivata, alla prossima %s.",
    :up_true => "Ti sei alzato",
    :up_false => "Sei gia' in piedi!",
    :down_true => "Ti sei adagiato per terra",
    :down_false => "Ti sei gia' per terra!",
    :uaresit_0 => "Sei per terra non puoi andare da nessuna parte!",
    :uaresit_1 => "Si nei tuoi sogni!",
    :nobody => "non c'e' nessuno",
    :onlyu => "solo tu",
    :c_e => "c'e'",
    :ci_sono => "ci sono",
    :cnf_0 => "Non ho capito...",
    :cnf_1 => "Puoi ripetere?",
    :cnf_2 => "Forse sbagli nella pronuncia?",
  }
  
  # Messaggio rappresentate una risposta o affermazione del bot.
  # Ogni messaggio e' indicizzato tramite un symbol/stringa.
  # @param [Symbol, String] label etichetta' che identifica il messaggio.
  # @return [String] messaggio in italiano.
  def _(label)
    return MSG_SET[label.to_sym]
  end
  
end
