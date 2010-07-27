#!/usr/bin/python -O

import socket, random

class IrcBot():
    delimeter = "\r\n";
    
    def __init__(self, nick, server, channel, port = 6667):
        self.nick = nick
        self.server = server
        self.channel = channel
        self.port = port
        
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((self.server, self.port))
        
        self.send("NICK %s" % self.nick)
        self.send("USER 666 %s PythonBot :%s" % (self.server, self.nick))
        self.send("JOIN %s" % self.channel)
        self.send("TOPIC %s dsadsadsadsa" % self.channel)
        
        while 1:
            ricev = self.s.recv(1024)
            print ricev
            
            user = ""
            cmd = ""
            chan = ""
            msg = ""
            try:
                tmp = ricev.split("!")
                user = tmp[0].lstrip(":")
                data = tmp[1].split(" ")
                cmd = data[1]
                chan = data[2]
                msg = data[3].lstrip(":")
            except:
                pass
            
            if ricev.startswith("PING "):
                self.send("PONG " + ricev.split()[1])            
            elif cmd == "KICK":
                self.send("JOIN %s" % self.channel)
            #elif cmd == "JOIN":
            #    if user != self.nick:
            #        self.send("PRIVMSG %s :Benvenuto..." % user)
            elif msg.find("ciao") != -1:
                self.send("PRIVMSG %s :Sto dormendo..." % self.channel)
            elif msg.find("vito") != -1:
                self.send("PRIVMSG %s :Vito e' nei campi" % self.channel)
        
    def send(self, msg):
        self.s.send(msg + self.delimeter)


if __name__ == "__main__":
    IrcBot("gmbot_%s" % random.randint(0, 1000), 
           "irc.freenode.net", 
           "#example")
