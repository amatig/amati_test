require "sqlite3"
require "thread"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def execute(query, hash_type = false)
    rows = []
    @mutex.synchronize do
      @conn.results_as_hash = hash_type
      begin
        rows = @conn.execute(query)
      rescue Exception => e
        puts "Database: " + e.message
      end
    end
    return rows
  end
  
  def select(hash_type, colums, tables, conditions = 1)
    return execute("select #{colums} from #{tables} where #{conditions}", hash_type)
  end
  
end
