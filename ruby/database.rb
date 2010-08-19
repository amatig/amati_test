require "sqlite3"
require "thread"

class Database
  
  def initialize(filename)
    @conn = SQLite3::Database.new filename
    # @conn.results_as_hash = true
    
    @mutex = Mutex.new
    Thread.abort_on_exception = true
  end
  
  def execute_lock(query)
    rows = []
    @mutex.synchronize do
      begin
        rows = @conn.execute(query)
      rescue Exception => e
        puts "Database: " + e.message
      end
    end
    return rows
  end
  
  def execute(query)
    rows = []
    begin
      rows = @conn.execute(query)
    rescue Exception => e
      puts "Database: " + e.message
    end
    return rows
  end
  
  def only_read(cols, tables, conds = 1)
    return execute "select #{cols} from #{tables} where #{conds}"
  end
  
  def read(cols, tables, conds = 1)
    return execute_lock "select #{cols} from #{tables} where #{conds}"
  end
  
end
