require "database.rb"
require "user.rb"

class Core < Database
  
  def initialize(filename)
    super filename
    @user_list = {}
  end
  
  def is_welcome?(user)
    return @user_list.key? user
  end
  
  def need_welcome()
    rows = select(true, "text", "messages", "label = 'rich_benvenuto'")
    return rows[0]["text"]
  end
  
  def welcome(user)
    @user_list[user] = User.new user
    rows = select(true, "text", "messages", "label = 'benvenuto'")
    return rows[0]["text"]
  end
  
  def cmd_not_found()
    cnf = [1, 2] # lista degli id dei messaggi di command not found
    pk = cnf[rand(cnf.length)]
    rows = select(true, "text", "messages", "id = #{pk}")
    return rows[0]["text"]
  end
  
  def up(user)
    temp = @user_list[user].up
    rows = select(true, "text", "messages", "label = 'up_#{temp}'")
    return rows[0]["text"]
  end
  
  def down(user)
    temp = @user_list[user].down
    rows = select(true, "text", "messages", "label = 'down_#{temp}'")
    return rows[0]["text"]
  end
  
  # temp
  def get_users()
    rows = select(false, "nick", "users")
    part1 = select(true, "text", "messages", "label = 'gu'")
    label = rows.length > 1 ? "gu_molti" : "gu_uno"
    part2 = select(true, "text", "messages", "label = '#{label}'")
    return part1[0]["text"] + " " + part2[0]["text"] + " " + rows.join(", ")
  end
  
end
