from stack_interface import StackInterface
import pjsua as pj
import threading

current_call = None

class Pjsip(StackInterface):
    
    def log_cb(self, level, str, len):
        print str,
        
    def __init__(self, config):
        self.config = config
        lib = pj.Lib()
        lib.init(log_cfg = pj.LogConfig(level = 4, callback = self.log_cb))        
        self.transport = lib.create_transport(pj.TransportType.UDP, 
                                             pj.TransportConfig(int(self.config["client"]["port"])))
        lib.start()
        self.acc = lib.create_account(pj.AccountConfig(self.config["account"]["domain"], 
                                                       self.config["account"]["ext"], 
                                                       self.config["account"]["passwd"]))
        acc_event = MyAccountCallback(self.acc)
        self.acc.set_callback(acc_event)
        #self.acc.set_transport(self.transport)
        acc_event.wait()
    
    def call(self):
        print "call"
    
    def answer(self):
        if current_call:
            current_call.answer(200)
    
    def bye(self):
        if current_call:
            current_call.hangup()
    
    def reject(self):
        print "reject"
    
    def hold(self):
        print "hold"
    
    def transfer(self):
        print "transfer"
    
    def registration(self):
        print "registration"
    
    def close(self):
        self.transport = None
        self.acc.delete()
        self.acc = None
        pj.Lib.instance().destroy()

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
    
    # Notification on incoming call
    def on_incoming_call(self, call):
        global current_call
        if current_call:
            call.answer(486, "Busy")
            return
        
        print "Incoming call from ", call.info().remote_uri
        print "Press 'a' to answer"
        
        current_call = call
        
        call_cb = MyCallCallback(current_call)
        current_call.set_callback(call_cb)
        
        current_call.answer(180)

class MyCallCallback(pj.CallCallback):
    
    def __init__(self, call = None):
        pj.CallCallback.__init__(self, call)
    
    # Notification when call state has changed
    def on_state(self):
        global current_call
        print "Call with", self.call.info().remote_uri,
        print "is", self.call.info().state_text,
        print "last code =", self.call.info().last_code,
        print "(" + self.call.info().last_reason + ")"
        
        if self.call.info().state == pj.CallState.DISCONNECTED:
            current_call = None
            print 'Current call is', current_call
    
    # Notification when call's media state has changed.
    def on_media_state(self):
        if self.call.info().media_state == pj.MediaState.ACTIVE:
            # Connect the call to sound device
            call_slot = self.call.info().conf_slot
            pj.Lib.instance().conf_connect(call_slot, 0)
            pj.Lib.instance().conf_connect(0, call_slot)
            print "Media is now active"
        else:
            print "Media is inactive"
