module SystemSettings
  
  def self.db_first_connection(sql)
    @@db = SQLite3::Database.new("settings.sqlite")
    file = File.new(sql, "r")
    while (line = file.gets)
      @@db.execute(line.chomp)
    end
    file.close
  end
  
  def self.db_connection
    @@db = SQLite3::Database.new("settings.sqlite")
  end
  
  def self.getServers
    rows = @@db.execute("select * from server")
    return rows
  end
  
  def self.getServer(name)
    rows = @@db.execute("select * from server where name='#{name}'")[0]
    return rows
  end
  
  def self.addServer(name, desc, type, ip, user, passwd)
    begin
      @@db.execute("insert into server (name, description, type, ip, user, passwd) values ('#{name}','#{desc}','#{type}','#{ip}','#{user}','#{passwd}')")
    rescue
    end
  end
  
  def self.updateServer(name, desc, type, ip, user, passwd)
    begin
      @@db.execute("update server set description='#{desc}', type='#{type}', ip='#{ip}', user='#{user}', passwd='#{passwd}' where name='#{name}'")
    rescue
    end
  end
  
  def self.delServer(name)
    begin
      serv = getServer(name)
      if serv
        @@db.execute("delete from server where name='#{name}'")
        rows = @@db.execute("select * from setting where name='current_server' and value=#{serv[0]}")
        delConnectServer if (rows and rows.size > 0)
      end
    rescue
    end
  end
  
  def self.getConnectServer
    rows = @@db.execute("select server.* from setting, server where setting.name='current_server' and setting.value=server.id")[0]
    return rows
  end
  
  def self.delConnectServer
    @@db.execute("delete from setting where name='current_server'")
  end
  
  def self.setConnectServer(name)
    serv = getServer(name)
    begin
      if serv
        rows = @@db.execute("select * from setting where name='current_server'")
        if (rows and rows.size > 0)
          @@db.execute("update setting set value='#{serv[0]}' where name='current_server'")
        else
          @@db.execute("insert into setting (name, value) values ('current_server', '#{serv[0]}')")
        end
      else
        serv = []
        delConnectServer
      end
    rescue
      serv = []
    end
    return [serv[1], serv[4]]
  end
  
end
