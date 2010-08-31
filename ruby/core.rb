require "database.rb"
require "cmd_msg.rb"
require "user.rb"

class Core < Database
  
  def initialize(*args)
    super *args
    @user_list = {}
  end
  
  def cmd_not_found()
    return say("cnf_#{rand 3}")
  end
  
  def is_welcome?(user)
    return (@user_list.key? user)
  end
  
  def need_welcome()
    return say(:r_benv)
  end
  
  def welcome(user, greeting)
    r = get("*", "users", "nick='#{user}'")
    unless r.empty?
      @user_list[user] = User.new(r)
      return "#{say :benv} #{place user}" % [greeting, bold(user)]
    else
      return say(:no_reg)
    end
  end
  
  def place(user)
    temp = @user_list[user].place
    r = get("name, descr, attrs", "places", "id=#{temp}")
    l = read("name, attrs", "links, places", "place=#{temp} and places.id=near_place")
    nel = "nel_" + r[2]
    np = []
    l.each do |p|
      temp = "art_" + p[1]
      np << "#{say temp} #{p[0]}"
    end
    return "#{say :pl} #{say nel} #{bold r[0]}, #{r[1]}. #{say :near} " + np.join(", ")
  end
  
  def up(user)
    return say("up_#{@user_list[user].up}")
  end
  
  def down(user)
    return say("down_#{@user_list[user].down}")
  end
  
  # test
  def get_users()
    r = read("nick", "users")
    temp = (r.length > 1) ? :ci_sono : :c_e
    return "#{say :gu} #{say temp} " + r.join(", ")
  end
  
end
