require "sqlite3"
require "thread"
require "user.rb"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    
    @user_list = []
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def select(hash_type, colums, tables, conditions = 1)
    rows = []
    @mutex.synchronize do
      @conn.results_as_hash = hash_type # boolean
      rows = @conn.execute("select #{colums} from #{tables} where #{conditions}")
    end
    return rows
  end
  
  # game
  
  def is_welcome?(user)
    return @user_list.include? user
  end
  
  def need_welcome()
    rows = select(true, "text", "messages", "label = 'rich_benvenuto'")
    return rows[0]["text"]
  end
  
  def welcome(user)
    @user_list.push user
    rows = select(true, "text", "messages", "label = 'benvenuto'")
    return rows[0]["text"]
  end
  
  def cmd_not_found()
    cnf = [1, 2] # lista degli id dei messaggi di command not found
    pk = cnf[rand(cnf.length)]
    rows = select(true, "text", "messages", "id = #{pk}")
    return rows[0]["text"]
  end
  
  def get_users()
    rows = select(false, "nick", "users")
    part1 = select(true, "text", "messages", "label = 'gu'")
    label = rows.length > 1 ? "gu_molti" : "gu_uno"
    part2 = select(true, "text", "messages", "label = '#{label}'")
    return part1[0]["text"] + " " + part2[0]["text"] + " " + rows.join(", ")
  end
  
end
