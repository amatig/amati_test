#!/usr/bin/ruby
require "logger"
require "satconn.rb"

#CONFIG
$filename = "./extensions.txt" # file contenete le estensioni da aggiornare 
                               # ogni riga ha estensione e un +/- (da aggiornare/aggiornata)
                               # es.
                               # 3309 +
                               # 3310 - (gia' aggiornata)

$num = 2                       # num max di tel da aggiornare contemporaneamente
$wait = 0                      # IMPOSTARE A 0 PER EVITARE DI TROVARE TUTTI I TELEFONI INATTIVI
                               # timeout per reboot di un telefono in sec (0 per disabilitare)
$time_check = 15               # frequenza in sec di controllo della procedura di restart
$delay_reboot = 5              # tempo in sec di delay perche' la procedura di restart sia iniziata
$start_time_h = [-1,-1]        # inizio attivita' [ora, minuti] ([-1,-1] per disattivare)
$end_time_h = [-1,-1]          # fine forzata attivita' [ora, minuti] ([-1,-1] per disattivare) 


# CONNECTION AVAYA
$ip = "192.168.65.106"
$port = "5022"
$user = "dadmin"
$passwd = "F8stdatate1#"
$pin = "dadmin1"
$tty = "513"                   # Tipo di terminale NON CAMBIARE


class App
  
  def load_exts()
    f = File.open(@filename, "r")
    f.each do |line| 
      temp = line.split(" ")
      (@exts << temp[0].split) if temp[1] == "+"
    end
    f.close
  end
  
  def busy_wait_loop()
    temp = @start_time + (60*3)
    while (Time.now < @start_time or Time.now > temp)
      sleep 30
    end
  end
  
  def initialize(log, ip, port, tty, user, passwd, pin, filename)
    @log = log
    @exts = []
    @filename = filename
    load_exts()
    return if @exts.empty?  ## if we have no more ext to manage exit

    @conn = SatConn.new(ip, port, user, passwd, pin)
    
    @pending = []
    @failed = []
    
    tmp = Time.now
    @start_time = Time.mktime(tmp.year, 
                              tmp.month , 
                              tmp.mday, 
                              (($start_time_h[0]>-1)? $start_time_h[0] : tmp.hour),
                              (($start_time_h[1]>-1)? $start_time_h[1] : tmp.min), 0) 
    @start_time += (60*60*24) if tmp > (@start_time + (60*3))
    @end_time = Time.mktime(@start_time.year, 
                            @start_time.month , 
                            @start_time.mday, 
                            (($end_time_h[0]>-1)? $end_time_h[0] : @start_time.hour),
                            (($end_time_h[1]>-1)? $end_time_h[1] : @start_time.min), 0)
    @end_time += (60*60*24) if @start_time >= @end_time
    puts "Scheduled time, start: "+ @start_time.to_s + " end: " + @end_time.to_s
    @log.info "Scheduled time, start: "+ @start_time.to_s + " end: " + @end_time.to_s
    
    busy_wait_loop ## waiting for start time
    status = @conn.connect(tty)
    if status
      start_working_loop()
    else
      puts "Error or timeout connection"
      @log.error "Error or timeout connection"
      close
    end
  end
  
  def start_working_loop()
    puts "Starting..."
    @log.info "Starting..."
    last_check = Time.now.to_i + $delay_reboot

    while ((not @exts.empty?) or (not @pending.empty?)) and
        (Time.now >= @start_time and Time.now < @end_time)
      if (not @exts.empty?) and (@pending.length < $num)
        update(@exts.shift)
        last_check = last_check + $delay_reboot
      end
      
      # check restart
      if Time.now.to_i - last_check > $time_check
        last_check = Time.now.to_i
        (@pending.length-1).downto(0) do |i|
          x = @pending[i]
          if Time.now.to_i - x[1] > $wait and $wait != 0
            @failed << x[0]
            @pending.delete(x)
            puts "Fail restart for timeout #{x[0]}"
            @log.warn "Fail restart for timeout #{x[0]}"
          else
            r = @conn.list_reg(x[0])
            if r[1] =~ /successfully/ and !r[2]
              @pending.delete(x)
              change_file(@filename, x[0])
              puts "Done #{x[0]}"
              @log.info "Done #{x[0]}"
            else
              state = (r[2] == true) ? " [but EMPTY]" : ""
              puts "Waiting restart #{x[0]}, #{r[1]}#{state}"
            end
          end
        end
      end
    end
    puts "Extensions failed #{@failed*', '}" unless @failed.empty?
    @log.error "Extensions failed #{@failed*', '}" unless @failed.empty?
    close
  end
  
  def close()
    @conn.close
  end
  
  def change_file(filename, ext)
    text = ""
    f = File.open(filename, "r")
    f.each do |line|
      temp = line.gsub!(/#{ext} \+/, "#{ext} -")
      text += (temp != nil) ? temp : line
    end
    f.close
    f = File.open(filename, "w+")
    f.write(text)
    f.close
  end
  
  def update(ext)
    r = @conn.list_reg(ext)
    if r[1] =~ /successfully/ and !r[2]
      puts "Start update #{ext}"
    else
      @failed << ext
      state = (r[2] == true) ? " [because EMPTY]" : ""
      puts "Fail update #{ext}, #{r[1]}#{state}"
      @log.error "Fail update #{ext}, #{r[1]}#{state}"
      return
    end
    r = @conn.busyout(ext)
    if r[1] =~ /successfully/
      puts "Busyout #{ext}"
    else
      @failed << ext
      puts "Fail busyout #{ext}, #{r[1]}"
      @log.error "Fail busyout #{ext}, #{r[1]}"
      return
    end
    r = @conn.rel(ext)
    if r[1] =~ /successfully/
      puts "Rel #{ext}"
    else
      @failed << ext
      puts "Fail rel #{ext}, #{r[1]}"
      @log.error "Fail rel #{ext}, #{r[1]}"
      return
    end
    @pending << [ext, Time.now.to_i]
  end
  
end


if __FILE__ == $0
  begin
    time = Time.now.to_a
    log = Logger.new("./log/iscript-avaya_#{time[3]}-#{time[2]}(#{time[1]}:#{time[0]}).log")
    # log.level = Logger::WARN
    App.new(log, $ip, $port, $tty, $user, $passwd, $pin, $filename)
  rescue Interrupt
  rescue Exception => e
    puts "MainLoop: " + e.message
    print e.backtrace.join("\n")
    log.error "MainLoop: " + e.message
    log.error e.backtrace.join("\n")
    #retry # ritenta dal begin
  ensure
  end
end
