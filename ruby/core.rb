require "database.rb"
require "user.rb"

class Core < Database
  
  def initialize(filename)
    super filename
    @user_list = {}
  end
  
  def cmd_not_found()
    cnf = [1, 2] # id dei messaggi di command not found
    pk = cnf[rand cnf.length]
    rows = select(true, "text", "messages", "id = #{pk}")
    return rows[0]["text"]
  end
  
  def is_welcome?(user)
    return @user_list.key? user
  end
  
  def need_welcome()
    rows = select(true, "text", "messages", "label='rich_benv'")
    return rows[0]["text"]
  end
  
  def welcome(user)
    rows = select(false, "nick", "users", "nick='#{user}'")
    if not rows.empty?
      @user_list[user] = User.new user
      rows = select(true, "text", "messages", "label='benv'")
    else
      rows = select(true, "text", "messages", "label='non_reg'")
    end
    return rows[0]["text"]
  end
    
  def up(user)
    temp = @user_list[user].up
    rows = select(true, "text", "messages", "label='up_#{temp}'")
    return rows[0]["text"]
  end
  
  def down(user)
    temp = @user_list[user].down
    rows = select(true, "text", "messages", "label='down_#{temp}'")
    return rows[0]["text"]
  end
  
  # test
  def get_users()
    part1 = select(true, "text", "messages", "label = 'gu'")
    rows = select(false, "nick", "users")
    n = rows.length > 1 ? "gu_molti" : "gu_uno"
    part2 = select(true, "text", "messages", "label = '#{n}'")
    return part1[0]["text"] + " " + part2[0]["text"] + " " + rows.join(", ")
  end
  
end
