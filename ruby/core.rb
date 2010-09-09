require "thread"
require "database.rb"
require "utils.rb"
require "user.rb"
require "npc.rb"

class Core
  
  def initialize()
    @db = Database.instance # singleton    
    @user_list = {}
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
    @npc_list = {}
    npcs = @db.read("name", "npc")
    npcs.each { |n| @npc_list[n[0]] = Npc.new(n[0]) }    
  end
  
  def is_welcome?(nick)
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
      return get_text(:benv) % [greeting, bold(nick), place(nick)]
    else
      return get_text(:no_reg)
    end
  end
  
  def move(nick, place_name)
    me = @user_list[nick]
    return get_text("uaresit_#{rand 2}") unless me.stand_up?
    find = nil
    me.near_place.each do |p|
      if p[1] =~ /#{place_name.strip}/i 
        find = p
        break
      end
    end
    if find
      me.move(find[0]) # sposta al place
      return place(nick)
    else
      return get_text(:no_pl)
    end
  end
  
  def place(nick)
    p = @user_list[nick].place
    temp = pa_in(a_d(p[3], p[1])) + bold(p[1])
    return get_text(:pl) % [temp, p[2]]
  end
  
  def near_place(nick)
    l = @user_list[nick].near_place
    temp = l.map { |p| pa_di(a_d(p[3], p[1])) + bold(p[1]) }
    return get_text(:np) % list(temp)
  end
  
  def up(nick)
    return get_text("up_#{@user_list[nick].up}")
  end
  
  def down(nick)
    return get_text("down_#{@user_list[nick].down}")
  end
  
  def look(nick, name)
    temp = @user_list[nick].place[0]
    o = @db.get("name", "npc", "place=#{temp} and name='#{name}'")
    return "#{o[0]}, #{@npc_list[o[0]].descr}" unless o.empty?
    # se nn e' un npc controlla gli oggetti con quel nome ecc
    # da fare ...
    return get_text(:nothing)
  end
  
  def users_zone(nick)
    me = @user_list[nick]
    npc = @db.read("name", "npc", "place=#{me.place[0]}")
    u = npc.map { |n| italic(n[0]) } # init u con gli npc
    @user_list.each_pair do |k, v|
      u << bold(v.to_s) if (v != me and v.place[0] == me.place[0])
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
