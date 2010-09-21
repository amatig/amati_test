require "pg"
require "singleton"

# = Description
# ...
# = License
# Nemesis - IRC Mud Multiplayer Online totalmente italiano
#
# Copyright (C) 2010 Giovanni Amati
#
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
# = Authors
# Giovanni Amati

class Database
  include Singleton
  
  # Connessione al db
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
  # = prova
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
    @conn.exec "update #{table} set #{temp*','} where #{conds}"
  end
  
  # inserisce una nuova entry, fdata e' un hash fields => value
  def insert(fdata, table)
    fields = fdata.keys
    values = fdata.values.map { |v| (v.class == String) ? "'#{v}'" : v }
    @conn.exec "insert into #{table} (#{fields*','}) values (#{values*','})"
  end
  
  def close()
    @conn.close if @conn
  end
  
end
