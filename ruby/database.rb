require "pg"
require "singleton"

class Database
  include Singleton
  
  def connect(host, port, db_name, user, pass = "")
    @conn = PGconn.connect(host, port, "", "", db_name, user, pass)
  end
  
  def exec(cols, query)
    # puts query
    result = []
    res = @conn.exec(query)
    if cols == ["*"]
      res.each do |row|
        result << row.map { |r| r[1].strip }
      end
    else
      cols = cols.map { |f| (f =~ /as\s(.+)$/i) ? $1 : f }
      cols = cols.map do |f| 
        f.rindex(".") ? f.slice(f.rindex(".") + 1, f.size) : f 
      end
      res.each do |row|
        result << cols.map { |f| row[f].strip }
      end
    end
    res.clear
    return result
  end
  
  # ritorna un array di tuple, ognuna e' 
  # un array di campi della select
  def read(cols, tables, conds = "true")
    return exec(cols, "select #{cols*','} from #{tables} where #{conds}")
  end
  
  # ritorna la prima tupla della query, 
  # un array dei campi della select
  def get(*args)
    temp = read(*args)
    return (temp.length > 0) ? temp[0] : temp
  end
  
  def close()
    @conn.close if @conn
  end
  
end
