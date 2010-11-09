require "thread"
require "lib/database.rb"
require "lib/utils.rb"
require "locate/messages_it.rb"
require "mod/user.rb"
require "mod/npc.rb"
require "mod/place.rb"

# Classe dei comandi/messaggi del mud.
# = Description
# Questa classe implementa l'elaborazione dei dati dei comandi utente e genera i messaggi di ritorno alla classe Mud che li invia al server Irc.
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
  include Utils
  include GetText
    
  # Una nuova istanza di Core.
  def initialize()
    @db = Database.instance # singleton
    
    @place_list = {}
    @npc_list = {}
    
    # caricamento dati mondo
    init_data
  end
  
  # Inizializza tutti gli elementi del gioco.
  def init_data()
    User.reset_login
    
    @place_list = {}
    places = @db.read("*", "places")
    places.each { |p| @place_list[Integer(p[0])] = Place.new(p) }
    places.each do |p|
      list_np = @db.read("places.id", 
                         "links,places", 
                         "place=#{p[0]} and places.id=nearby_place")
      temp = list_np.map { |near| @place_list[Integer(near[0])] }
      @place_list[Integer(p[0])].init_nearby_place(temp)
    end
    
    @npc_list = {}
    npcs = @db.read("name", "npcs")
    npcs.each do |n|
      temp = Npc.new(n[0])
      @npc_list[temp.name] = temp
      @place_list[temp.place].add_people(temp)
    end
  end
  
  # Messaggio random per un comando sconosciuto.
  # @return [String] messaggio del mud.
  def cmd_not_found()
    return _("cnf_#{rand 3}")
  end
  
  # Test comunicazione in canale.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def test(nick)
    return _(:test) % nick
  end
  
  # Indica se l'utente e' loggato o no nel sistema, 
  # ritorna false anche nel caso non esiste.
  # @param [String] nick identificativo dell'utente.
  # @return [Boolean] stato della login utente.
  def logged?(nick)
    return User.logged?(nick)
  end
  
  # Modalita' di interazione dell'utente.
  # @param [String] nick identificativo dell'utente.
  # @return [String] stato della modalita' di interazione dell'utente.
  def get_user_mode(nick)
    return User.get_mode(nick)
  end
  
  # Effettua il login di un utente dal sistema.
  # @param [String] nick identificativo dell'utente.
  # @param [String] greeting parola usata dall'utente per salutare.
  # @return [String] messaggio del mud.
  def login(nick, greeting = nil)
    return _(:r_benv) if greeting == nil
    if User.login(nick)
      @place_list[User.get_place(nick)].add_people(nick)
      return _(:benv) % [greeting, bold(nick), place(nick)]
    else
      return _(:no_reg)
    end
  end
  
  # Effettua il logout di un utente dal sistema.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def logout(nick)
    User.logout(nick)
    @place_list[User.get_place(nick)].remove_people(nick)
    return _(:logout) % nick
  end
  
  # Aggiorna il timestamp dell'utente, che indica il momento dell'ultimo
  # messaggio inviato.
  # @param [String] nick identificativo dell'utente.
  def update_timestamp(nick)
    User.update_timestamp(nick)
  end
  
  # Muove l'utente in un posto vicino (collegato) a quello attuale.
  # @param [String] nick identificativo dell'utente.
  # @param [String] place_name nome del luogo in cui ci si vuole spostare.
  # @return [String] messaggio del mud.
  def move(nick, place_name)
    return _("uaresit_#{rand 2}") unless User.stand_up?(nick)
    @place_list[User.get_place(nick)].nearby_place.each do |p|
      if p.name =~ /#{place_name.strip}/i
        @place_list[User.get_place(nick)].remove_people(nick)
        User.set_place(nick, p.id) # cambio di place_id
        p.add_people(nick)
        temp = pa_in(a_d(p.attrs, p.name)) + bold(p.name)
        return _(:new_pl) % [temp, p.descr]
      end
    end
    return _(:no_pl) % place_name
  end
  
  # Descrizione del posto in cui e' l'utente.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def place(nick)
    p = @place_list[User.get_place(nick)]
    temp = pa_in(a_d(p.attrs, p.name)) + bold(p.name)
    return _(:pl) % [temp, p.descr]
  end
  
  # Elenca i posti vicini in cui si puo andare.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def nearby_place(nick)
    l = @place_list[User.get_place(nick)].nearby_place
    temp = l.map { |p| pa_di(a_d(p.attrs, p.name)) + bold(p.name) }
    return _(:np) % conc(temp)
  end
  
  # Fa alzare l'utente.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def up(nick)
    return _("up_#{User.up(nick)}")
  end
  
  # Fa abbassare l'utente.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def down(nick)
    return _("down_#{User.down(nick)}")
  end
  
  # Descrizione di un npc, oggetto o altro.
  # @param [String] nick identificativo dell'utente.
  # @param [String] name nome dell'utente/npc/oggetto da esaminare.
  # @return [String] messaggio del mud.
  def look(nick, name)
    @place_list[User.get_place(nick)].get_people.each do |p|
      if p.class == Npc
        return _(:desc_npc) % [p.name, p.descr] if p.name =~ /^#{name.strip}$/i
      else
        return _(:desc_people) if p =~ /^#{name.strip}$/i
      end
    end
    # se nn e' un npc controlla gli oggetti con quel nome ecc
    # da fare ...
    return _(:nothing) % name
  end
  
  # Entra in modalita' interazione 'dialogo' con un npc.
  # @param [String] nick identificativo dell'utente.
  # @param [String] name nome dell'npc.
  # @return [String] messaggio dell'npc o del mud.
  def speak(nick, name)
    @place_list[User.get_place(nick)].get_people.each do |p|
      if (p.class == Npc and p.name =~ /^#{name.strip}$/i)
        User.set_mode(nick, "dialog", p.name)
        return npc_interaction(nick, "ciao")
      end
    end
    return _(:nothing) % name
  end
  
  # Demanda all'npc l'interazione vera e propria con l'utente.
  # @param [String] nick identificativo dell'utente.
  # @param [String] msg messaggio utente.
  # @return [String] messaggio npc.
  def npc_interaction(nick, msg)
    temp = @npc_list[User.get_target(nick)].parse(nick, msg)
    if temp =~ /(arrivederci|addio|a presto|alla prossima)/i
      User.set_mode(nick, "move", "")
    end
    return temp
  end
  
  # Elenca gli npc ed utenti nella zona.
  # @param [String] nick identificativo dell'utente.
  # @return [String] messaggio del mud.
  def users_zone(nick)
    u = []
    @place_list[User.get_place(nick)].get_people.each do |p|
      unless p.class == Npc
        u << bold(p) if (p != nick)
      else
        u << italic(p.name)
      end
    end
    if u.empty?
      c = _(:nobody) + ","
      u = [_(:onlyu)]
    else
      c = _((u.length > 1) ? :ci_sono : :c_e)
    end
    return _(:uz) % [c, conc(u)]
  end
  
  private :init_data
end
