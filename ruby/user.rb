require "thread"
require "lib/database.rb"

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

class User
  attr_reader :id, :name
  
  # Metodo di classe che ritorna una instanza di tipo User creata
  # dai dati utente nel database presi tramite l'argomento <em>nick</em>.
  def User.get(nick)
    data = Database.instance.get("*", "users", "nick='#{nick}'")
    return (data.empty?) ? nil : User.new(data)
  end
  
  # Metodo di inizializzazione della classe.
  # [data] array contenete tutti i dati dell'utente.
  def initialize(data)
    @db = Database.instance # singleton
    
    @id, @name, @place = data
    @stand_up = true
    @timestamp = Time.now.to_i
    
    @mutex_attrs = Mutex.new
    @mutex_place = Mutex.new
    @mutex_time = Mutex.new
    Thread.abort_on_exception = true
  end
  
  # Salva lo stato dell'utente nel database.
  def save()
    @mutex_attrs.synchronize do
      @db.update({
                   "place" => Integer(@place),
                 }, 
                 "users", 
                 "id=#{@id}")
    end
  end
  
  # Aggiorna il timestamp dell'utente, questa variabile tiene traccia
  # del tempo dell'ultimo messaggio inviato dall'utente al fine
  # sloggarlo per inattivita' salvandone lo stato.
  def update_timestamp()
    @mutex_time.synchronize { @timestamp = Time.now.to_i }
  end
  
  # Ritorna il timestamp dell'utente, il tempo dell'ultimo messaggio inviato.
  def timestamp()
    @mutex_time.synchronize { return @timestamp }
  end
  
  # Modifica l'id del posto in cui si trova l'utente.
  def set_place(place_id)
    @mutex_place.synchronize { @place = place_id }
  end
  
  # Ritorna l'id del posto in cui si trova l'utente.
  def place()
    @mutex_place.synchronize { return @place }
  end
  
  # Setta l'utente come 'in piedi'. Se l'utente non era tale
  # ritorna true, se era gia' 'in piedi' ritorna false.
  def up()
    @mutex_attrs.synchronize do
      return false if @stand_up
      @stand_up = true
      return true
    end
  end
  
  # Setta l'utente come 'per terra'. Se l'utente non era tale
  # ritorna true, se era gia' 'per terra' ritorna false.
  def down()
    @mutex_attrs.synchronize do
      return false unless @stand_up
      @stand_up = false
      return true
    end
  end
  
  # Ritorna un booleano che indica se l'utente e' 'in piedi' o no.
  def stand_up?()
    @mutex_attrs.synchronize { return @stand_up }
  end
  
  # Ritorna una stringa che rappresenta il nome dell'utente.
  def to_s()
    return @name
  end
  
end
