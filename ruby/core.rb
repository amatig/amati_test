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
      return "#{say :benv} #{place user}" % [greeting, color(:b, user)]
    else
      return say(:no_reg)
    end
  end
  
  def place(user)
    temp = @user_list[user].place
    r = get("name, descr, attrs", "places", "id=#{temp}")
    temp = "nel_" + r[2]
    return "#{say :pl} #{say temp} " + r[0..-2].join(", ")
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
