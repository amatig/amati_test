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
    rows = only_read("text", "messages", "id = #{pk}")
    return rows[0][0]
  end
  
  def is_welcome?(user)
    return @user_list.key? user
  end
  
  def need_welcome()
    rows = only_read("text", "messages", "label='rich_benv'")
    return rows[0][0]
  end
  
  def welcome(user)
    rows = only_read("nick", "users", "nick='#{user}'")
    if not rows.empty?
      @user_list[user] = User.new user
      rows = only_read("text", "messages", "label='benv'")
    else
      rows = only_read("text", "messages", "label='non_reg'")
    end
    return rows[0][0]
  end
    
  def up(user)
    temp = @user_list[user].up
    rows = only_read("text", "messages", "label='up_#{temp}'")
    return rows[0][0]
  end
  
  def down(user)
    temp = @user_list[user].down
    rows = only_read("text", "messages", "label='down_#{temp}'")
    return rows[0][0]
  end
  
  # test
  def get_users()
    part1 = only_read("text", "messages", "label = 'gu'")
    rows = only_read("nick", "users")
    n = rows.length > 1 ? "gu_molti" : "gu_uno"
    part2 = only_read("text", "messages", "label = '#{n}'")
    return part1[0][0] + " " + part2[0][0] + " " + rows.join(", ")
  end
  
end
