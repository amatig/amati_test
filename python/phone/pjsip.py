from stack_interface import StackInterface
import pjsua as pj
import threading

class Pjsip(StackInterface):
    
    def __init__(self, config):
        self.config = config
        self.lib = pj.Lib()
        self.lib.init(log_cfg = pj.LogConfig(level = 4, callback = self.log_cb))        
        self.transport = self.lib.create_transport(pj.TransportType.UDP, 
                                                   pj.TransportConfig(int(self.config["client"]["port"])))
        self.lib.start()
        acc = self.lib.create_account(pj.AccountConfig(self.config["account"]["domain"], 
                                                       self.config["account"]["ext"], 
                                                       self.config["account"]["passwd"]))
        acc_event = MyAccountCallback(acc)
        acc.set_callback(acc_event)
        acc.set_transport(self.transport)
        acc_event.wait()
        
        self.registration()
    
    def log_cb(self, level, str, len):
        print str,
    
    def call(self):
        print "call"
    
    def answer(self):
        print "answer"
    
    def bye(self):
        print "bye"
    
    def reject(self):
        print "reject"
    
    def hold(self):
        print "hold"
    
    def transfer(self):
        print "transfer"
    
    def registration(self):
        print "registration"
    
    def close(self):
        self.lib.destroy()
        self.lib = None
        print "close"

class MyAccountCallback(pj.AccountCallback):
    sem = None
    
    def __init__(self, account = None):
        pj.AccountCallback.__init__(self, account)
        
    def wait(self):
        self.sem = threading.Semaphore(0)
        self.sem.acquire()
        print "acquire"
        
    def on_reg_state(self):
        print "reg state"
        print self.account.info().reg_status
        if self.sem:
            if self.account.info().reg_status >= 200:
                self.sem.release()
