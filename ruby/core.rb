require "thread"
require "database.rb"
require "utils.rb"
require "user.rb"

class Core
  
  def initialize()
    @db = Database.instance
    @user_list = {}
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def cmd_not_found()
    return get_text("cnf_#{rand 3}")
  end
  
  def is_welcome?(user)
    return (@user_list.key? user)
  end
  
  def need_welcome()
    return get_text(:r_benv)
  end
  
  def welcome(user, greeting)
    u = User.get(user)
    if u
      @mutex.synchronize do
        @user_list[user] = u
      end
      return get_text(:benv) % [greeting, bold(user), place(user)]
    else
      return get_text(:no_reg)
    end
  end
  
  def move(user, place_name)
    me = @user_list[user]
    return get_text("uaresit_#{rand 2}") unless me.stand_up?
    l = @db.read(["places.id", "name"], 
                 "links,places", 
                 "place=#{me.place} and places.id=near_place")
    find = nil
    l.each { |p| (find = p; break) if p[1] =~ /#{place_name.strip}/i }
    if find
      me.set_place(find[0])
      return place(user)
    else
      return get_text(:no_pl)
    end
  end
  
  def place(user)
    temp = @user_list[user].place
    p = @db.get(["name", "descr", "attrs"], "places", "id=#{temp}")
    temp = pa_in(a_d(p[2], p[0])) + bold(p[0])
    return get_text(:pl) % [temp, p[1]]
  end
  
  def near_place(user)
    temp = @user_list[user].place
    l = @db.read(["name", "attrs"], 
                 "links,places", 
                 "place=#{temp} and places.id=near_place")
    l = l.map { |p| pa_di(a_d(p[1], p[0])) + bold(p[0]) }
    return get_text(:np) % list(l)
  end
  
  def up(user)
    return get_text("up_#{@user_list[user].up}")
  end
  
  def down(user)
    return get_text("down_#{@user_list[user].down}")
  end
  
  def look(user, name)
    temp = @user_list[user].place
    o = @db.get(["name", "descr"], 
                "npc,locations", 
                "place=#{temp} and npc.id=npc and name='#{name}'")
    return o.join(", ") unless o.empty? # per ora solo npc
    # se nn e' un npc controlla gli oggetti con quel nome ecc
    # da fare ...
    return get_text(:nothing)
  end
  
  def users_zone(user)
    me = @user_list[user]
    npc = @db.read(["name"], 
                   "npc,locations", 
                   "place=#{me.place} and npc.id=npc")
    u = npc.map { |n| italic(n[0]) } # init u con gli npc
    @user_list.each_pair do |k, v|
      u << bold(v.to_s) if (v != me and v.place == me.place)
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
