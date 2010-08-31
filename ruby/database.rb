begin
  $_vers = true
  require "pg"
rescue
  $_vers = false
  require "postgres"
end

class Database
  
  def initialize(host, port, db_name, user, pass = "")
    @conn = PGconn.connect(host, port, "", "", db_name, user, pass)
  end
  
  def exec(query)
    # puts query
    result = []
    res = @conn.exec(query)
    res.each do |row|
      result << row.collect { |col| $_vers ? col[1].strip : col.strip }
    end
    res.clear
    return result
  end
  
  # ritorna un array di tuple, ognuna e' 
  # un array di campi della select
  def read(fields, tables, conds = "true")
    return exec("select #{fields} from #{tables} where #{conds}")
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
