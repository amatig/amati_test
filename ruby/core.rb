require "database.rb"
require "user.rb"

class Core < Database
  
  def initialize(*args)
    super *args
    @user_list = {}
  end
  
  def cmd_not_found()
    cnf = [1, 2] # id dei messaggi di command not found
    pk = cnf[rand(cnf.length)]
    r = read("text", "messages", "id=#{pk}")
    return r[0][0]
  end
  
  def is_welcome?(user)
    return @user_list.key? user
  end
  
  def need_welcome()
    r = read("text", "messages", "label='rich_benv'")
    return r[0][0]
  end
  
  def welcome(user)
    flag = false
    r = read("*", "users", "nick='#{user}'")
    if not r.empty?
      @user_list[user] = User.new user
      flag = true
      r = read("text", "messages", "label='benv'")
    else
      r = read("text", "messages", "label='non_reg'")
    end
    temp = r[0][0]
    temp += " #{place user}" if flag
    return temp
  end
  
  def place(user)
    p1 = read("text", "messages", "label='pl'")
    temp = @user_list[user].place
    p2 = read("name, descr", "places", "id=#{temp}")
    return "#{p1[0][0]} " + p2[0].join(", ")
  end
  
  def up(user)
    temp = @user_list[user].up
    r = read("text", "messages", "label='up_#{temp}'")
    return r[0][0]
  end
  
  def down(user)
    temp = @user_list[user].down
    r = read("text", "messages", "label='down_#{temp}'")
    return r[0][0]
  end
  
  # test
  def get_users()
    p1 = read("text", "messages", "label='gu'")
    r = read("nick", "users")
    n = r.length > 1 ? "gu_molti" : "gu_uno"
    p2 = read("text", "messages", "label='#{n}'")
    return "#{p1[0][0]} #{p2[0][0]} " + r.join(", ")
  end
  
end
