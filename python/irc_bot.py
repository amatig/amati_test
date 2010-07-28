#!/usr/bin/python -O

# Questo BOT e' implementato per poter non essere sempre presente nel canale.
# Funziona tenedo il ChanServ come operatore nella stanza che, alla connessione 
# del BOT, gli assegna diritti di operatore. 
# Il BOT deve essere aggiunto al GROUP del creatore della stanza o comunque 
# avere diritti sul ChanServ.

import sys, socket, re, random, time

class IrcBot():
    delimeter = "\r\n";
    
    def __init__(self, nick, realname, password, server, channel, port = 6667):
        self.nick = nick
        self.realname = realname
        self.password = password
        self.server = server
        self.channel = channel
        self.port = port
        
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((self.server, self.port))
        
        self.send("NICK %s" % self.nick)
        self.send("USER %s %s %s :%s" % (self.nick, 
                                         self.nick,
                                         self.server, 
                                         self.realname))
        if self.password:
            self.send("NS identify %s" % self.password)
        
        time.sleep(15)
        self.send("JOIN %s" % self.channel)
        self.send("CS op %s %s" % (self.channel, self.nick))
        #self.send("TOPIC %s Test" % self.channel)
        
        while 1:
            ricev = self.s.recv(1024)
            print ricev
            
            if ricev.startswith("PING "):
                self.send("PONG " + ricev.split()[1])            
            else:
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
                
                if cmd == "KICK":
                    self.send("JOIN %s" % self.channel)
                elif cmd == "JOIN":
                    if user != self.nick:
                        self.send("PRIVMSG %s :Benvenuto..." % user)
                elif msg.find("ciao") != -1:
                    if chan != self.nick:
                        self.send("PRIVMSG %s :Sto dormendo..." % chan)
                    else:
                        self.send("PRIVMSG %s :Sto dormendo..." % user)
        
    def send(self, msg):
        self.s.send(msg + self.delimeter)


if __name__ == "__main__":
    IrcBot("game_master",
           "Game Master",
           len(sys.argv) > 1 and sys.argv[1] or None,
           "irc.freenode.net", 
           "#sleipnir")
