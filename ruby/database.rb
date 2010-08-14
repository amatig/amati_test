require "sqlite3"
require "thread"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    
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
  
  def welcome()
    pk_msgs = [3] # lista degli id dei messaggi nella tabella messages
    pk = pk_msgs[rand(pk_msgs.length)]
    rows = select(true, "text", "messages", "id = #{pk}")
    return rows[0]["text"]
  end
  
  def cmd_not_found()
    cnf = [1, 2] # lista degli id dei messaggi nella tabella messages
    pk = cnf[rand(cnf.length)]
    rows = select(true, "text", "messages", "id = #{pk}")
    return rows[0]["text"]
  end
  
  def get_users()
    rows = select(false, "nick", "users")
    n = rows.length > 1 ? "ci sono" : "c'e'"
    return "Nella zona #{n} " + rows.join(", ")
  end
  
end
