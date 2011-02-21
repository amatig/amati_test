#!/usr/bin/env python

import sys
try:
    import pygtk
    pygtk.require("2.0")
except:
    pass
try:
    import gtk
    import gtk.glade
except:
    sys.exit(1)

import pjsua as pj
import threading

current_call = None

def log_cb(level, str, len):
    print str,

class MyAccountCallback(pj.AccountCallback):
    sem = None

    def __init__(self, account = None):
        pj.AccountCallback.__init__(self, account)

    def wait(self):
        self.sem = threading.Semaphore(0)
        self.sem.acquire()
        print "ciao"

    def on_reg_state(self):
        print "qui"
        print self.account.info().reg_status
        if self.sem:
            if self.account.info().reg_status >= 200:
                self.sem.release()
    
    # Notification on incoming call
    def on_incoming_call(self, call):
        print "call"
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

# Callback to receive events from Call
class MyCallCallback(pj.CallCallback):

    def __init__(self, call=None):
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

class Main:
    
    def __init__(self):        
        # Set the Glade file
        self.gladefile = "gui.glade"  
        self.wTree = gtk.glade.XML(self.gladefile)         
        # Get the Main Window, and connect the "destroy" event
        self.window = self.wTree.get_widget("window1")
        if (self.window):
            dic = { "on_button1_clicked" : self.clicked,
                    "on_window1_destroy" : self.quit }
            self.wTree.signal_autoconnect(dic)
        
        self.lib = pj.Lib()
        self.lib.init(log_cfg = pj.LogConfig(level=4, callback=log_cb))
        
        transport = self.lib.create_transport(pj.TransportType.UDP, pj.TransportConfig(5069))
        
        self.lib.start()
        
        acc_conf = self.lib.create_account(pj.AccountConfig("192.168.64.228", "200", "200"))
        acc_event = MyAccountCallback(acc_conf)
        acc_conf.set_callback(acc_event)
        #acc_conf.set_registration(True)
        acc_conf.set_transport(transport)
        acc_event.wait()
        
    def clicked(self, ev):
        print "ciao"
        
    def quit(self, ev):
        self.lib.destroy()
        self.lib = None
        gtk.main_quit
        sys.exit(0)

if __name__ == "__main__":
    hwg = Main()
    gtk.main()
