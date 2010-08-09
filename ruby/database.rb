require "sqlite3"
require "thread"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    
    @mutex_conn = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def process(user, extra, target, msg)
    #puts Thread.current
    data = nil
    case msg.strip
    when /ciao/i
      data = "PRIVMSG #{user} :Ciao..."
    when /^chi.*qui\?$/i
      data = "PRIVMSG #{user} :#{get_users}"
    end
    
    return data
  end
  
  def select(colums, tables, conditions = 1)
    row = []
    @mutex_conn.synchronize do
      row = @conn.execute("select #{colums} from #{tables} where #{conditions}")
    end
    return row
  end
  
  def get_users()
    row = select("*", "users")
    n = row.length > 1 ? "ci sono" : "c'e'"
    return "Nella zona #{n} " + row.join(", ")
  end
  
end
