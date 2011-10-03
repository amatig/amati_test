require "rubygems"
require "net/ssh"
require "net/ssh/telnet"
require "satlang.rb"

class SatConn

  def initialize(ip, port, user, passwd, pin)
    @ip = ip
    @port = port
    @user = user
    @passwd = passwd
    @pin = pin
    time = Time.now.to_a
    @logfile = "./log/connection_#{time[3]}-#{time[2]}(#{time[1]}:#{time[0]}).log"
  end
  
  def connect(tty, ssh=nil)
    ssh = Net::SSH.start(@ip, @user, :password => @passwd, :port => @port) if ssh==nil
    @socket = Net::SSH::Telnet.new("Dump_log" => @logfile,
                                   "Session" => ssh,
                                   'Waittime' => 0.3,
                                   'Prompt' => /.*/,
                                   'Telnetmode' => false,
                                   "Verbose" => Logger::DEBUG)
    status1 = timeout do 
      @socket.waitfor("String" => "Pin\:")
      @socket.puts(@pin)
    end
    status2 = timeout do
      @socket.waitfor("String" => "\[513\]") if status1
      @socket.puts(tty)
      @socket.waitfor("String" => "Command\:")
    end
    return status2
  end
  
  def close()
    timeout do
      @socket.puts("logoff")
      @socket.waitfor("String" => "Proceed\ With\ Logoff\:")
      @socket.puts("y")
      @socket.close if @socket
    end
  end
  
  def list_reg(ext)
    return send_command("list reg e #{ext}", "Command\:")
  end
  
  def busyout(ext)
    return send_command("busyout sta #{ext}", "Command\:")
  end
  
  def rel(ext)
    return send_command("rel sta #{ext}", "Command\:")
  end
  
  def send_command(command, search_string)
    command_check = ""
    net_buff = ""
    timeout do
      @socket.puts(command)
      command_check = command.split(" ")[0].strip
      @socket.waitfor("String" => search_string) do |recvdata|
        net_buff << recvdata
      end
    end
    res = SatLang.parse(net_buff)
    if res[0].match(command_check)
      return res
    else
      return [command, "error parse return command", false]
    end
  end
  
  def timeout(time = 30)
    Timeout::timeout(time) do
      yield
    end
    return true
  rescue Exception => e
    puts e
    return false
  end
  
  private :timeout, :send_command
  
end
