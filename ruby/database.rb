require "pg"

class Database
  
  def initialize(host, port, db_name, user, pass)
    @conn = PGconn.connect(host, port, "", "", db_name, user, pass)
  end
  
  def exec(query)
    result = []
    res = @conn.exec(query)
    res.each do |row|
      result << row.map { |col| col[1].strip }
    end
    res.clear
    return result
  end
  
  def read(cols, tables, conds = "true")
    return exec("select #{cols} from #{tables} where #{conds}")
  end
  
  def get(*args)
    temp = read(*args)
    return (temp.length > 0) ? temp[0] : []
  end
  
  def close()
    @conn.close if @conn
  end
  
end
