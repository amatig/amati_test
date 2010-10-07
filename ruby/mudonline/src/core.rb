require "thread"
require "lib/database.rb"
require "lib/utils.rb"
require "mod/user.rb"
require "mod/npc.rb"
require "mod/place.rb"

include Utils

# = Description
# Classe che implementa l'elaborazione dei dati dei comandi utente e genera i messaggi di ritorno del Mud.
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

class Core
  @@bot_msg = {
    :save => "terro' presente il punto in cui la storia e' arrivata",
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
    :uaresit_0 => "sei per terra non puoi andare da nessuna parte!",
    :uaresit_1 => "si nei tuoi sogni!",
    :c_e => "c'e'",
    :ci_sono => "ci sono",
    :uz => "nella zona %s %s",
    :nobody => "non c'e' nessuno",
    :onlyu => "solo tu",
    :nothing => "%s? Non c'e' nessun oggetto o persona corrispondente a quel nome qui!",
    :pl => "ti trovi %s, %s",
    :no_pl => "%s? Non conosco nessun luogo nelle vicinanze con questo nome!",
    :np => "sei nelle vicinanze %s",
  }
  
  # Metodo di inizializzazione della classe.
  def initialize()
    @db = Database.instance # singleton    
    @user_list = {}
    @place_list = {}
    @npc_list = {}
    
    @mutex = Mutex.new
    
    load_data
    # controllo attivita' utente
    Thread.new do
      while true do
        @user_list.each_pair do |k, v|
          v.save # salva ogni 30 sec
          if (Time.new.to_i - v.timestamp >= 60)
            @mutex.synchronize { @user_list.delete(k) }
          end
        end
        sleep 30
      end
    end
  end
  
  # Inizializza la mappa del mondo, npc, ecc...
  def load_data()
    @place_list = {}
    places = @db.read("*", "places")
    places.each { |p| @place_list[p[0]] = Place.new(p) }
    places.each do |p|
      temp = @db.read("places.id", 
                      "links,places", 
                      "place=#{p[0]} and places.id=near_place")
      temp.each do |near|
        # i near_place devono essere aggiunti solo i volta
        # mai piu modificati
        @place_list[p[0]].near_place << @place_list[near[0]]
      end
    end
    
    @npc_list = {}
    npcs = @db.read("name", "npc")
    npcs.each do |n|
      temp = Npc.new(n[0])
      @npc_list[n[0]] = temp
      @place_list[temp.place].add_people(temp)
    end
  end
  
  # Ritorna un booleano che indica se l'utente e' stato identificato
  # o no dal sistema.
  def is_welcome?(nick)
    return (@user_list.key? nick)
  end
  
  # Aggiorna il timestamp dell'utene, che indica il momento dell'ultimo
  # messaggio inviato.
  def update_timestamp(nick)
    @user_list[nick].update_timestamp
  end
  
  # Salva lo stato dell'utente e lo cominica con un messaggio di ritorno.
  def save(nick)
    @user_list[nick].save
    return get_text(:save)
  end
  
  # Ritorna un messaggio random di comando non conosciuto.
  def cmd_not_found()
    return get_text("cnf_#{rand 3}")
  end
  
  # Ritorna un messaggio che indica la necessita di riconoscersi,
  # di effettuare una sorta di autenticazione/login.
  def need_welcome()
    return get_text(:r_benv)
  end
  
  # Ritorna un messaggio di benvenuto e il posto in cui e' l'utente.
  def welcome(nick, greeting)
    u = User.get(nick)
    if u
      @mutex.synchronize { @user_list[nick] = u }
      @place_list[u.place].add_people(u)
      return get_text(:benv) % [greeting, bold(nick), up_case(place(nick))]
    else
      return get_text(:no_reg)
    end
  end
  
  # Muove l'utente in un posto vicino, collegato a quello attuale e
  # ritorna un messaggio con nuovo nome del posto e descrizione o
  # un messaggio di fallito spostamento.
  def move(nick, place_name)
    me = @user_list[nick]
    return get_text("uaresit_#{rand 2}") unless me.stand_up?
    find = nil
    @place_list[me.place].near_place.each do |p|
      if p.name =~ /#{place_name.strip}/i 
        find = p
        break
      end
    end
    if find
      @place_list[me.place].remove_people(me)
      me.set_place(find.id) # cambio di place_id
      @place_list[me.place].add_people(me)
      return place(nick)
    else
      return get_text(:no_pl) % place_name
    end
  end
  
  # Ritorna il posto e descrizione in cui e' l'utente.
  def place(nick)
    p = @place_list[@user_list[nick].place]
    temp = pa_in(a_d(p.attrs, p.name)) + bold(p.name)
    return get_text(:pl) % [temp, p.descr]
  end
  
  # Ritorna la lista dei posti vicini in cui si puo andare.
  def near_place(nick)
    l = @place_list[@user_list[nick].place].near_place
    temp = l.map { |p| pa_di(a_d(p.attrs, p.name)) + bold(p.name) }
    return get_text(:np) % list(temp)
  end
  
  # Fa alzare l'utente e ritorna un messaggio di esito.
  def up(nick)
    return get_text("up_#{@user_list[nick].up}")
  end
  
  # Fa abbassare l'utente e ritorna un messaggio di esito.
  def down(nick)
    return get_text("down_#{@user_list[nick].down}")
  end
  
  # Ritorna la descrizione di un npc, oggetto o altro.
  def look(nick, name)
    temp = @user_list[nick].place
    res = nil
    @place_list[temp].people.each do |p|
      if (p.class == Npc and p.name == name)
        res = p
        break
      end
    end
    return "#{res.name}, #{res.descr}" if res
    # se nn e' un npc controlla gli oggetti con quel nome ecc
    # da fare ...
    return get_text(:nothing) % name
  end
  
  # Ritorna la lista degli npc ed utenti nella zona.
  def users_zone(nick)
    me = @user_list[nick]
    u = []
    @place_list[me.place].people.each do |p|
      if p.class == User
        u << bold(p.name) if (p != me)
      else
        u << italic(p.name)
      end
    end
    if u.empty?
      c = get_text(:nobody) + ","
      u = [get_text(:onlyu)]
    else
      c = get_text((u.length > 1) ? :ci_sono : :c_e)
    end
    return get_text(:uz) % [c, list(u)]
  end
  
  # Ritorna una stringa rappresentate una risposta o affermazione del bot, 
  # ogni messaggio e' indicizzato tramite un symbol/stringa.
  def get_text(str)
    return @@bot_msg[str.to_sym]
  end
  
  private :load_data, :get_text
end
