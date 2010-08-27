require "database.rb"
require "user.rb"

class Core < Database
  
  def initialize(*args)
    super *args
    @user_list = {}
  end
  
  def cmd_not_found()
    cnf = [1, 2, 20] # id dei messaggi di command not found
    pk = cnf[rand(cnf.length)]
    return get("text", "messages", "id=#{pk}")[0]
  end
  
  def is_welcome?(user)
    return (@user_list.key? user)
  end
  
  def need_welcome()
    return get("text", "messages", "label='r_benv'")[0]
  end
  
  def welcome(user)
    r = get("*", "users", "nick='#{user}'")
    unless r.empty?
      @user_list[user] = User.new(r)
      r = get("text", "messages", "label='benv'")[0] % user
      r += " #{place user}"
    else
      r = get("text", "messages", "label='no_reg'")[0]
    end
    return r
  end
  
  def place(user)
    p1 = get("text", "messages", "label='pl'")[0]
    temp = @user_list[user].place
    p2 = get("name, descr", "places", "id=#{temp}")
    return "#{p1} " + p2.join(", ")
  end
  
  def up(user)
    temp = @user_list[user].up
    return get("text", "messages", "label='up_#{temp}'")[0]
  end
  
  def down(user)
    temp = @user_list[user].down
    return get("text", "messages", "label='down_#{temp}'")[0]
  end
  
  # test
  def get_users()
    p1 = get("text", "messages", "label='gu'")[0]
    r = read("nick", "users")
    n = (r.length > 1) ? "ci_sono" : "c_e"
    p2 = get("text", "messages", "label='#{n}'")[0]
    return "#{p1} #{p2} " + r.join(", ")
  end
  
end
