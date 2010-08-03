#!/usr/bin/python -O

from threading import Thread
import sys, socket, re, random, time

class IrcBot(Thread):
    delimeter = "\r\n";
    
    def __init__(self, nick, realname, server, port = 6667):
        Thread.__init__(self)
        self.nick = nick
        self.realname = realname
        self.server = server
        self.port = port        
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.s.connect((self.server, self.port))
        self.send("USER %s %s bla :%s\r\nNICK %s" % (self.nick, 
                                                     self.nick,
                                                     self.realname,
                                                     self.nick))
        
    def run(self):
        time.sleep(2)
        self.send("PRIVMSG game_master :ciao")
        
        while 1:
            ricev = self.s.recv(1024)
            if ricev.find("dormendo") != -1:
                ricev
                break
        
    def send(self, msg):
        self.s.send(msg + self.delimeter)

if __name__ == "__main__":
    n = 4
    c = []
    t = time.time()
    for i in xrange(n):
        b = IrcBot("test_%d" % random.randint(0, 1000000),
                   "test",
                   "127.0.0.1")
        b.start()
        c.append(b)
        
    for e in c:
        e.join()
    print "Fine ", time.time() - t
