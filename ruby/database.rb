require "pg"
require "singleton"

class Database
  include Singleton
  
  def connect(host, port, db_name, user, pass = "")
    @conn = PGconn.connect(host, port, "", "", db_name, user, pass)
  end
  
  def exec2(query)
    # puts query
    result = []
    res = @conn.exec(query)
    res.each do |row|
      result << res.fields.map { |f| row[f].strip }
    end
    res.clear
    return result
  end
  
  # ritorna un array di tuple, ognuna e' 
  # un array di campi della select
  def read(fields, tables, conds = "true")
    return exec2("select #{fields} from #{tables} where #{conds}")
  end
  
  # ritorna la prima tupla della query, 
  # un array dei campi della select
  def get(fields, tables, conds = "true")
    temp = read(fields, tables, conds + " LIMIT 1")
    return (temp.length > 0) ? temp[0] : temp
  end
  
  # aggiorna i campi di una tabella, fdata e' un hash fields => value
  def update(fdata, table, conds = "true")
    temp = []
    fdata.each_pair do |k, v|
      vv = (v.class == String) ? "'#{v}'" : v
      temp << "#{k}=#{vv}"
    end
    @conn.exec("update #{table} set #{temp*','} where #{conds}")
  end
  
  # inserisce una nuova entry, fields e values sono stringhe
  def insert(fields, values, table)
    @conn.exec("insert into #{table} (#{fields}) values (#{values})")
  end
  
  def close()
    @conn.close if @conn
  end
  
end
