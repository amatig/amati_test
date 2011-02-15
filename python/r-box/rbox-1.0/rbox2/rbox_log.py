from twisted.python import logfile
from twisted.internet import reactor
from singleton import Singleton
import time

class rboxLog(Singleton):
    
    MAP_LEVEL = ["DEBUG", "INFO", "NOTICE", "WARNING", "ERR", "CRIT", "ALERT" , "EMERG"]
    
    def initialize(self, descrictor):
        self.path = descrictor["path"] 
        self.filename = descrictor["filename"]
        try:
            self.level = self.MAP_LEVEL.index(descrictor["loglevel"])
        except:
            self.level = 0
        self.__log = logfile.LogFile(self.filename, descrictor["path"])
        self.flush()
        
    def write(self, msg_type, msg, level = "NOTICE"):
        if self.MAP_LEVEL.index(level) >= self.level:
            self.__log.write("[%s] [%s] %s: %s\n" % (time.strftime("%d/%m/%y %H:%M:%S"), level, msg_type, msg))
        
    def flush(self):
        self.__log.flush()
        reactor.callFromThread(reactor.callLater, 10, self.flush)
