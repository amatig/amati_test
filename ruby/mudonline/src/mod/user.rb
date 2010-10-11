require "lib/database.rb"

# = Description
# Classe che rappresenta l'entita' utente.
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
  
  # Resetta i login degli utenti.
  def User.reset_login()
    Database.instance.update({"logged" => 0}, "users", "logged=1")
  end
  
  # Ritorna true se esiste l'utente nel database ed e' loggato,
  # altrimenti false.
  def User.logged?(nick)
    data = Database.instance.get("logged", "users", "nick='#{nick}'")
    return (not data.empty? and data[0] == "1")
  end
  
  # Imposta l'utente come loggato e ritorna true/false in base all'esito.
  def User.login(nick)
    data = Database.instance.get("logged", "users", "nick='#{nick}'")
    if not data.empty?
      Database.instance.update({"logged" => 1, "timestamp" => Time.now.to_i},
                               "users", 
                               "nick='#{nick}'")
      return true
    else
      return false
    end
  end
  
  # Imposta l'utente come sloggato.
  def User.logout(nick)
    Database.instance.update({"logged" => 0}, "users", "nick='#{nick}'")
  end
  
  # Modifica l'id del posto in cui si trova l'utente.
  def User.set_place(nick, place_id)
    Database.instance.update({"place" => Integer(place_id)}, 
                             "users", 
                             "nick='#{nick}'")
  end
  
  # Ritorna l'id del posto in cui si trova l'utente.
  def User.get_place(nick)
    data = Database.instance.get("place", "users", "nick='#{nick}'")
    return Integer(data[0])
  end
  
  # Aggiorna il timestamp dell'utente, questa variabile tiene traccia
  # del tempo dell'ultimo messaggio inviato dall'utente al fine
  # sloggarlo per inattivita'.
  def User.update_timestamp(nick)
    Database.instance.update({"timestamp" => Time.now.to_i}, 
                             "users", 
                             "nick='#{nick}'")
  end
  
  # Ritorna il timestamp dell'utente, il tempo dell'ultimo messaggio inviato.
  def User.get_timestamp(nick)
    data = Database.instance.get("timestamp", "users", "nick='#{nick}'")
    return Integer(data[0])
  end
  
  # Setta l'utente come 'in piedi'. Se l'utente non era tale
  # ritorna true, se era gia' 'in piedi' ritorna false.
  def User.up(nick)
    data = Database.instance.get("stand_up", "users", "nick='#{nick}'")
    if (data[0] == "1")
      return false
    else
      Database.instance.update({"stand_up" => 1}, "users", "nick='#{nick}'")
      return true
    end
  end
  
  # Setta l'utente come 'per terra'. Se l'utente non era tale
  # ritorna true, se era gia' 'per terra' ritorna false.
  def User.down(nick)
    data = Database.instance.get("stand_up", "users", "nick='#{nick}'")
    if (data[0] == "0")
      return false
    else
      Database.instance.update({"stand_up" => 0}, "users", "nick='#{nick}'")
      return true
    end
  end
  
  # Ritorna un booleano che indica se l'utente e' 'in piedi' o no.
  def User.stand_up?(nick)
    data = Database.instance.get("stand_up", "users", "nick='#{nick}'")
    return (data[0] == "1")
  end
  
end
