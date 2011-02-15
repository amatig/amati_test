from singleton import Singleton
from twisted.web import client
from twisted.internet import reactor
from xml.marshal import generic
from rbox_log import rboxLog
from origin import originFactory
from dest import destFactory
import urllib, os


def is_steel_valid(target):
    def security_check(*args, **kwargs):
        obj = base_settings()
        if not obj.state_error:
            return target(*args, **kwargs)
        else:
            return False
    return security_check


class base_settings(Singleton):
    
    def initialize(self, server, port):
        self.server = server
        self.port = port
        self.pid = os.getpid()
        self.state_error = False
        self.base_conf = None
        self.sched = None
        self.route = None
        self.origin = None
        self.force_end = None
        self.dest = None
        self.pending_action_count = 0
        self._log = None
        self.sync()
        self.all_done = False
        self._get_list = self.get_move_list
        
    def _base_init(self, data):
        self.base_conf = generic.loads(data)
        if self.base_conf.has_key("LOG"):
            self._log = rboxLog(self.base_conf["LOG"])
            self.get_sched()

        
    def _base_fail(self, info):
        self.state_error = True
        self._log.write("BASE FAIL", info, "INFO")
        reactor.stop()
        
    def _send_post_done(self, data):
        self.pending_action_count-=1
        
    def _send_post_fail(self, data):
        self.state_error = True
        self._log.write("SEND RECORDS FAIL", data, "INFO")
        
    def _resend_post_done(self, data):
        self.pending_action_count-=1
        
    def _resend_post_fail(self, data):
        self.state_error = True
        self._log.write("SCHED FAIL", data, "INFO")
        
    def _scan_done(self, data):
        self._log.write("SCAN DONE", data, "INFO")
        
    def _scan_fail(self, data):
        self.state_error = True
        self._log.write("SCAN FAIL", data, "INFO")
        
    def _origin_init(self, data):
        self.origin = originFactory().allocateOrigin(generic.loads(data))
        self._log.write("LAST SEEN", self.origin.last_seen, "INFO")
        
    def _origin_fail(self, info):
        self.state_error = True
        reactor.callLater(5,self._base_fail, info)
        
    def _dest_init(self, data):
        self.dest = destFactory().allocateDest(generic.loads(data))
        
    def _dest_fail(self, info):
        self.state_error = True
        reactor.callLater(5,self._base_fail, info)
        
    def _send_confirm_done(self,info):
        try:
            if self.origin.list_of_moved == [] and self.all_done:
                self.send_notify("BASE: Ended synching route(%s)"%(self.route), "INFO"); 
                self.send_final_done()
        except Exception, e:
            self._log.write("CONFIRM EXCEPT", e, "INFO")
            reactor.stop()
        
    def _send_confirm_fail(self, info):
        self._log.write("CONFIRM FAIL", info, "INFO")
        
    def  _final_done_done(self, data):
        self._log.write("FINAL DONE", data, "INFO")
        reactor.stop()
        
    def  _final_done_fail(self, data):
        self.state_error = True
        self._log.write("FINAL FAIL", data, "INFO")
        reactor.stop()
        
    def _movelist_done(self, data):
        move = generic.loads(data)
        if move.__len__() > 0:
            self.origin.move_list(move)
            reactor.callLater(20, self._get_list)
        else:
            self.origin.move_list(move) #empty request just for send all done stuff
            self.all_done = True
        
    def _movelist_fail(self, data):
        self.state_error = True
        self._get_list = self.move_ended
        self._log.write("MOVE FAIL", data, "INFO")
        reactor.callLater(5,self._base_fail, data)
        
    def _sched_init(self, data):
        #we are hired for a specific work
        activity = generic.loads(data)
        try:
            self.route = activity["route"]
            self.get_origin(activity["origin"])
            self.get_dest(activity["dest"])
            self.force_end = activity["endtime"]
            self._log.write("BASE SETTINGS", "GOT A WORK, %s, %s, %s"%(self.route, activity["origin"], activity["dest"]), "INFO")
            self.send_notify("BASE: Start synching route(%s)"%(self.route), "INFO"); 
        except Exception, e:
            self._log.write("BASE SETTINGS", type(e), "INFO")
            self._final_done_done("no activity in schedule")
        
    def _sched_fail(self, info):
        self.state_error = True
        reactor.callLater(5,self._base_fail, info)

    @is_steel_valid
    def sync(self):
        try:
            client.getPage("http://%s:%d/rest/basic/settings/"%(self.server, self.port)
                           ).addCallback(self._base_init).addErrback(self._base_fail)
        except Exception, e:
            self._log.write("HTTP SETTINGS", e, "INFO")
    
    @is_steel_valid
    def get_sched(self):
        try:
            client.getPage("http://%s:%d/rest/schedule/next/"%(self.server,self.port)
                           ).addCallback(self._sched_init).addErrback(self._sched_fail)
        except Exception, e:
            self._log.write("HTTP NEXT SCHED", e, "INFO")
    
    @is_steel_valid
    def get_origin(self, obj):
        try:
            client.getPage("http://%s:%d/rest/origin/%s/"%(self.server,self.port, obj)
                           ).addCallback(self._origin_init).addErrback(self._origin_fail)
        except Exception, e:
            self._log.write("HTTP ORIGIN", e, "INFO")
        
    @is_steel_valid
    def get_dest(self, obj):
        try:
            client.getPage("http://%s:%d/rest/dest/%s/"%(self.server,self.port, obj)
                           ).addCallback(self._dest_init).addErrback(self._dest_fail)
        except Exception, e:
            self._log.write("HTTP DEST", e, "INFO")
        
    def send_revisited_records(self, fold):
        tmp = generic.dumps(fold)
        self.pending_action_count += 1
        try:
            client.getPage("http://%s:%d/rest/records/recheck/"%(self.server,self.port),
                           method='POST',
                           postdata=urllib.urlencode({"data" : tmp}),
                           headers={'Content-Type':'application/x-www-form-urlencoded'}
                           ).addCallback(self._send_post_done).addErrback(self._send_post_fail)
        except Exception, e:
            self._log.write("HTTP REC RECHECK", e, "INFO")
        
    def send_records(self, fold):
        tmp = generic.dumps(fold)
        self.pending_action_count += 1
        try:
            client.getPage("http://%s:%d/rest/records/deliver/"%(self.server,self.port),
                           method='POST',
                           postdata=urllib.urlencode({"data" : tmp}),
                           headers={'Content-Type':'application/x-www-form-urlencoded'}
                           ).addCallback(self._send_post_done).addErrback(self._send_post_fail)
        except Exception, e:
            self._log.write("HTTP REC DELIVER", e, "INFO")
        
    def send_scan_done(self, code):
        try:
            client.getPage("http://%s:%d/rest/origin/scan/done/%s/"%(self.server,self.port, code)
                           ).addCallback(self._scan_done).addErrback(self._scan_fail)
        except Exception, e:
            self._log.write("HTTP SCAN DONE", e, "INFO")
        
    def get_move_list(self):
        try:
            client.getPage("http://%s:%d/rest/schedule/list/%s/"%(self.server, self.port, self.route)
                           ).addCallback(self._movelist_done).addErrback(self._movelist_fail)
        except Exception, e:
            self._log.write("HTTP SCHED LIST", e, "INFO")
        
    def move_ended(self):
        self._log.write("SCHED MOVE", "Move ended", "INFO")
        
    def send_ack(self, l):
        try:
            tmp = generic.dumps(l)
            client.getPage("http://%s:%d/rest/records/confirm/"%(self.server,self.port),
                           method='POST',
                           postdata=urllib.urlencode({"data" : tmp}),
                           headers={'Content-Type':'application/x-www-form-urlencoded'}
                           ).addCallback(self._send_confirm_done).addErrback(self._send_confirm_fail)
        except Exception, e:
            self._log.write("HTTP REC CONFIRM", e, "INFO")
        
    def get_conf_Section(self, section):
        if self.base.has_key(section):
            return self.base[section]
        else:
            return {}
        
    def send_final_done(self):
        try:
            client.getPage("http://%s:%d/rest/schedule/done/%s/"%(self.server,self.port,self.route)
                           ).addCallback(self._final_done_done).addErrback(self._final_done_fail)
        except Exception, e:
            self._log.write("HTTP SCHED DONE", e, "INFO")
        
    def full_sync(self):
        if self.pending_action_count == 0:
            self._log.write("FULL SYNC", "Start synching", "INFO")
            self._get_list()
            self._log.write("FULL SYNC", "All done", "INFO")
        else:
            reactor.callLater(2,self.full_sync)



    def _notify_done(self,data):
        pass

    def _notify_fail(self,data):
        self._log.write("SEND NOTIFY", "FAIL SENDING", "ERR")


    def send_notify(self, msg, level):
        ErrLevel = {
            "INFO": 1,
            "WARN": 0,
            "ERR": -1,
            }
        results = {}
        results["level"] = ErrLevel[level]
        results["msg"] = msg
        try:
            tmp = generic.dumps(results)
            client.getPage("http://%s:%d/rest/notify/%d/"%(self.server,self.port, self.pid),
                           method='POST',
                           postdata=urllib.urlencode({"data" : tmp}),
                           headers={'Content-Type':'application/x-www-form-urlencoded'}
                           ).addCallback(self._notify_done).addErrback(self._notify_fail)
        except Exception, e:
            self._log.write("HTTP NOTIFY", e, "INFO")
