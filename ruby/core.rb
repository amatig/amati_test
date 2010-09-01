require "database.rb"
require "utils.rb"
require "user.rb"

class Core < Database
  
  def initialize(*args)
    super *args
    @user_list = {}
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
    u = get("*", "users", "nick='#{user}'")
    unless u.empty?
      @user_list[user] = User.new(u)
      return "#{get_text :benv} #{place user}" % [greeting, bold(user)]
    else
      return get_text(:no_reg)
    end
  end
  
  def move(user, place_name)
    temp = @user_list[user].place
    l = read("name", "links, places", "place=#{temp} and places.id=near_place")
    place_name = place_name.strip
    if (l.include? [place_name])
      p = get("id", "places", "name=#{place_name}")
      @user_list[user].set_place(p[0])
      return place(user)
    else
      return get_text(:no_pl)
    end
  end
  
  def place(user)
    temp = @user_list[user].place
    p = get("name, descr, attrs", "places", "id=#{temp}")
    pa = pa_in(a_d(p[2], p[0]))
    return "#{get_text :pl} #{pa}#{bold p[0]}, #{p[1]}"
  end
  
  def near_place(user)
    temp = @user_list[user].place
    l = read("name, attrs", "links, places", "place=#{temp} and places.id=near_place")
    l = l.map { |p| pa_di(a_d(p[1], p[0])) + bold(p[0]) }
    return "#{get_text :np} #{list l}"
  end
  
  def up(user)
    return get_text("up_#{@user_list[user].up}")
  end
  
  def down(user)
    return get_text("down_#{@user_list[user].down}")
  end
  
  # test
  def get_users()
    u = read("nick", "users")
    u = u.map { |e| bold(e[0]) }
    c = (u.length > 1) ? :ci_sono : :c_e
    return "#{get_text :gu} #{get_text c} #{list u}"
  end
  
end
