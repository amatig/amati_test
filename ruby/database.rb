require "sqlite3"
require "thread"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    @mutex_db = Mutex.new
    
    Thread.abort_on_exception = true
  end
  
  def process(user, extra, target, msg)
    #puts Thread.current
    case msg.strip
    when /ciao/i
      return "PRIVMSG #{user} :sto dormendo..."
    when /^chi.*qui?/i
      return "PRIVMSG #{user} :#{get_users}"
    end
    
    return nil
  end
  
  def get_users()
    row = []
    @mutex_db.synchronize do
      row = @conn.execute("select * from users")
    end
    n = row.length > 1 ? "ci sono" : "c'e'"
    return "Nella zona #{n} " + row.join(", ")
  end
end
