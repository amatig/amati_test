#!/usr/bin/python -O

import socket, re, random

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
        self.send("USER %s %s %s :%s" % (self.nick, 
                                         self.server,
                                         self.server, 
                                         self.nick))
        self.send("JOIN %s" % self.channel)
        self.send("TOPIC %s GdrTest" % self.channel)
        
        while 1:
            ricev = self.s.recv(1024)
            print ricev
            
            user = ""
            cmd = ""
            chan = ""
            msg = ""
            
            m = re.search("^:(.*)!(.*)\ (.*)\ (.*)\ :(.*)$", ricev)
            try:
                msg = m.group(5)
                user = m.group(1)
                cmd = m.group(3)
                chan = m.group(4)
            except:
                m = re.search("^:(.*)!(.*)\ (.*)\ :(.*)$", ricev)
                try:
                    user = m.group(1)
                    cmd = m.group(3)
                    chan = m.group(4)
                except:
                    pass
            
            if ricev.startswith("PING "):
                self.send("PONG " + ricev.split()[1])            
            elif cmd == "KICK":
                self.send("JOIN %s" % self.channel)
            elif cmd == "JOIN":
                if user != self.nick:
                    self.send("PRIVMSG %s :Benvenuto..." % user)
            elif msg.find("ciao") != -1:
                self.send("PRIVMSG %s :Sto dormendo..." % user)
            elif msg.find("vito") != -1:
                self.send("PRIVMSG %s :Vito e' nei campi" % user)
        
    def send(self, msg):
        self.s.send(msg + self.delimeter)


if __name__ == "__main__":
    IrcBot("gmbot_%s" % random.randint(0, 1000), 
           "irc.freenode.net", 
           "#amati2010")
