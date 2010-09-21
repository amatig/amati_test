require "thread"
require "lib/database.rb"
require "lib/utils.rb"
require "user.rb"
require "place.rb"
require "npc.rb"

# = Description
# ...
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
  
  def initialize()
    @db = Database.instance # singleton    
    @user_list = {}
    @place_list = {}
    @npc_list = {}
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
    
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
  
  def load_data()
    @place_list = {}
    places = @db.read("*", "places")
    places.each { |p| @place_list[p[0]] = Place.new(p) }
    places.each do |p|
      temp = @db.read("places.id", 
                      "links,places", 
                      "place=#{p[0]} and places.id=near_place")
      temp.each do |near|
        @place_list[p[0]].add_near_place(@place_list[near[0]])
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
  
  def is_welcome?(nick)  # :yields: nick
    return (@user_list.key? nick)
  end
  
  def update_timestamp(nick)
    @user_list[nick].update_timestamp
  end
  
  def save(nick)
    @user_list[nick].save
    return get_text(:save)
  end
  
  def cmd_not_found()
    return get_text("cnf_#{rand 3}")
  end
  
  def need_welcome()
    return get_text(:r_benv)
  end
  
  def welcome(nick, greeting)
    u = User.get(nick)
    if u
      @mutex.synchronize { @user_list[nick] = u }
      @place_list[u.place].add_people(u)
      return get_text(:benv) % [greeting, bold(nick), place(nick)]
    else
      return get_text(:no_reg)
    end
  end
  
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
      return get_text(:no_pl)
    end
  end
  
  def place(nick)
    p = @place_list[@user_list[nick].place]
    temp = pa_in(a_d(p.attrs, p.name)) + bold(p.name)
    return get_text(:pl) % [temp, p.descr]
  end
  
  def near_place(nick)
    l = @place_list[@user_list[nick].place].near_place
    temp = l.map { |p| pa_di(a_d(p.attrs, p.name)) + bold(p.name) }
    return get_text(:np) % list(temp)
  end
  
  def up(nick)
    return get_text("up_#{@user_list[nick].up}")
  end
  
  def down(nick)
    return get_text("down_#{@user_list[nick].down}")
  end
  
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
    return get_text(:nothing)
  end
  
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
  
end
