require "pg"
require "singleton"

# Classe singleton che gestisce l'interazione con il database Postgres Server.
# = Description
# Classe singleton che gestisce l'interazione con il database Postgres Server.
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
  
  # Apre una connessione ad un database di un server postgres.
  # @param [String] host indirizzo del server postgres.
  # @param [Integer] port porta del server postgres.
  # @param [String] db_name identificativo del database.
  # @param [String] user identificativo dell'utente postgres.
  # @param [String] pass password dell'utente postgres.
  def connect(host, port, db_name, user, pass = "")
    @conn = PGconn.connect(host, port, "", "", db_name, user, pass)
  end
  
  # Chiude la connessione verso il server postgres.
  def close()
    @conn.close if @conn
  end
  
  # Esegue una query sul database ritornando dati ben strutturati.
  # @param [String] query query SQL standard.
  # @return [Array of Array<String>] lista di tuple risultanti.
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
  
  # Ritorna una serie di tuple.
  # @param [String] fields campi di interesse.
  # @param [String] tables nomi delle tabelle concatenate da virgola.
  # @param [String] conds condizioni della selezione.
  # @return [Array of Array<String>] lista di tuple risultanti dalla selezione.
  def read(fields, tables, conds = "true")
    return exec2("select #{fields} from #{tables} where #{conds}")
  end
  
  # Ritorna una precisa tupla.
  # @param [String] fields campi di interesse.
  # @param [String] tables nomi delle tabelle concatenate da virgola.
  # @param [String] conds condizioni della selezione.
  # @return [Array<String>] tupla del risultato della selezione.
  def get(fields, tables, conds = "true")
    temp = read(fields, tables, conds + " LIMIT 1")
    return (temp.length > 0) ? temp[0] : temp
  end
  
  # Aggiorna i valori dei campi di una tupla.
  # @param [Hash] fdata contiene i campi (key) e i nuovi valori (value).
  # @param [String] table identificativo della tabella.
  # @param [String] conds condizioni di selezione.
  def update(fdata, table, conds = "true")
    temp = []
    fdata.each_pair do |k, v|
      vv = (v.class == String) ? "'#{v}'" : v
      temp << "#{k}=#{vv}"
    end
    @conn.exec "update #{table} set #{temp*','} where #{conds}"
  end
  
  # Inserisce una nuova tupla.
  # @param [Hash] fdata contiene i campi (key) e i valori (value).
  # @param [String] table identificativo della tabella.
  def insert(fdata, table)
    fields = fdata.keys
    values = fdata.values.map { |v| (v.class == String) ? "'#{v}'" : v }
    @conn.exec "insert into #{table} (#{fields*','}) values (#{values*','})"
  end
  
  private :exec2
end
