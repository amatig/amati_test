#!/usr/bin/python -O

""" 
Questo BOT e' implementato per poter non essere sempre presente nel canale.
Funziona tenedo il ChanServ come operatore nella stanza che, alla connessione 
del BOT, gli assegna diritti di operatore. 
Il BOT deve essere aggiunto al GROUP del creatore della stanza o comunque 
avere diritti sul ChanServ.
"""

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
        
        self.send("JOIN %s" % self.channel)
        self.send("CS op %s %s" % (self.channel, self.nick))
        #self.send("TOPIC %s Test" % self.channel)
        
        while 1:
            ricev = self.s.recv(1024)
            print ricev
            
            if ricev.startswith("PING "):
                self.send("PONG " + ricev.split()[1])            
            else:
                prefix, cmd, args = self.parse(ricev)
                user = prefix.split("!")[0]
                
                if cmd == "KICK":
                    if args[1] == self.nick:
                        self.send("JOIN %s" % args[0])
                        self.send("CS op %s %s" % (args[0], self.nick))
                elif cmd == "JOIN":
                    if user != self.nick:
                        self.send("PRIVMSG %s :Benvenuto..." % user)
                elif cmd == "NOTICE":
                    pass
                elif cmd == "PRIVMSG":
                    if args[1].find("ciao") != -1:
                        if args[0] != self.nick:
                            self.send("PRIVMSG %s :Sto dormendo..." % args[0])
                        else:
                            self.send("PRIVMSG %s :Sto dormendo..." % user)
    
    def send(self, msg):
        self.s.send(msg + self.delimeter)
    
    def parse(self, s):
        if not s:
            return "", "", ""
        prefix = ""
        trailing = []
        if s[0] == ":":
            prefix, s = s[1:].split(" ", 1)
        if s.find(" :") != -1:
            s, trailing = s.split(" :", 1)
            args = s.split()
            args.append(trailing)
        else:
            args = s.split()
        command = args.pop(0)
        return prefix, command, args        


if __name__ == "__main__":
    IrcBot("game_master",
           "Game Master",
           len(sys.argv) > 1 and sys.argv[1] or None,
           "irc.astrolink.org", 
           "#provola")
