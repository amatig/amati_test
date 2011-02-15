#from twisted.internet import reactor, threads
#from twisted.web import client
#from threading import Lock
from branching import branchManager
from rbox_log import rboxLog
import shutil, os, subprocess

class BaseDriver(object):
    
    def __init__(self, descriptor):
        self.m_limit = 500
        self._base_init(descriptor)
        self.code = descriptor["code"]
        self.ip = descriptor["ip"]
        self.path = descriptor["path"]
        self.bc = descriptor["bc"]
        self.list_of_moves = []
        self.list_of_moved = []
        self.is_running = False
        self.need_tmp = False
        self.need_sync = descriptor["to_be_check"]
        try:
            self.last_seen = descriptor["last_known"]
        except:
            self.last_seen = 0
        self._recheck()
        if self.need_sync > 0:
            self._log.write(self.__class__.__name__, "Fs Sync Requested", "INFO")
            self._start_scann()
        self.run_full_sync()
    
    def _base_init(self, descriptor):
        self.code = descriptor["code"]
        self.ip = descriptor["ip"]
        self.path = descriptor["path"]
        self.bc = descriptor["bc"]
        self._log = rboxLog()

    def run_full_sync(self):
        from base_settings import base_settings
        base_settings().full_sync()
        
    def move_list(self, move):
        self.list_of_moves.extend(move)
        if not self.is_running:
            self.is_running = True
            self.run_sync()

    def _scan_recursive(self, base, l, deep):
        l.sort(lambda a,b: a>b and -1 or 1)
        if deep<3:
            for i in l:
                temp = os.sep.join([base, i])
                l1 = self.oper_listdir(temp)
                got = self._scan_recursive(temp, l1, deep+1)
                if got!=0:
                    return got
        else:
            for f in l:
                if f.endswith("wav"):
                    try:
                        f1 = int(f[0:15])
                        return f[0:15]
                    except:
                        pass
        return 0

    def push(self, src, dst):
        pass
        
    def run_sync(self):
        from base_settings import base_settings
        bs = base_settings()
        tmp = bs.dest.get_temp()
        if self.need_tmp:  # definisce se serve effettivamente il file tmp
            if tmp == None:
                self._log.write("NEED TMP", "USE ORIGIN TMP", "INFO")
        else:
            tmp = None
        while 1:
            try:
                l = self.list_of_moves.pop(0)
                b = branchManager()
                b.set_path(l[1])
                f = os.sep.join([self.path, b.get_abs_path()])
                if tmp != None:
                    self._log.write("NEED TMP", "Move to tmp", "INFO")
                    f2 = os.sep.join([tmp, b.get_path()])
                    self.push(f, f2);
                    f = f2
                    # sposto ed f diventa il percorso da tmp
                try:
                    bs.dest.push(f, l[1])
                    self.list_of_moved.append(l[0])
                    if self.list_of_moved.__len__() > self.m_limit:
                        tmp = self.list_of_moved
                        self.list_of_moved = []
                        bs.send_ack(tmp)
                except:
                    pass
            except IndexError, e:
                self.is_running = False
                tmp = self.list_of_moved
                self.list_of_moved = []
                bs.send_ack(tmp)
                break
    
    def oper_listdir(self, path):
        pass

    def _recheck(self):
        from base_settings import base_settings
        bs = base_settings()
        if self.last_seen == "None":
            return 0
        last = self.last_seen
        b = branchManager()
        b.set_path(last)

        first = str(long(self.last_seen)-self.bc).zfill(15)
        if first < b.min():
            first = b.get_path()
        self._log.write(self.__class__.__name__, "Starting Recheck %s, %s , %s"%(first, last, self.bc), "INFO")
        self._get_file_info(first, last, bs.send_revisited_records)
        
    def _start_scann(self):
        from base_settings import base_settings
        bs = base_settings()
        bs.scan = False
        last = self.find_last_wav()
        first = (self.last_seen!="None" and self.last_seen or "000000000000000")
        self._log.write(self.__class__.__name__, "Fs Sync found %s, %s"%(first, last), "INFO")
        self._get_file_info(first, last, bs.send_records)
        bs.send_scan_done(self.code)


class LocalFold(BaseDriver):
    
    def __init__(self, descriptor):
        BaseDriver.__init__(self, descriptor)
        
    def find_last_wav(self):
        return self._scan_recursive(self.path, [self.code], -1)
    
    def _get_file_info(self, first, last, deliver):
        counter = branchManager()
        counter.set_path(first)
        if counter.get_code() != "000000":
            counter.increment()
        else:
            counter.set_code(self.code)
        scan_result = {}
        i = 0
        self._log.write(self.__class__.__name__, "the duality first:%s, last:%s"%(counter.get_path(), last), "INFO")
        while counter.get_path() <= last:
            if i >= self.m_limit:
                deliver(scan_result)
                scan_result = {}
                i = 0
            f = counter.get_path()
            w = os.sep.join([self.path,counter.get_abs_path("wav")])
            x = os.sep.join([self.path,counter.get_abs_path("xml")])
            if os.path.isfile(w) and os.path.isfile(x):
                tmp = os.stat(w)
                scan_result[f] = {}
                scan_result[f]["wav_size"] = tmp.st_size
                scan_result[f]["wav_time"] = tmp.st_ctime
                tmp = os.stat(x)
                scan_result[f]["xml_size"] = tmp.st_size
            #counter = str(int(counter)+1).zfill(15) # take it signed for historical reason    
            counter.increment()
            i+=1
        deliver(scan_result)

    def oper_listdir(self, path):
        return os.listdir(path)
        
    def push(self, src, dst):
        shutil.copyfile(src+".wav",dst+".wav")
        shutil.copyfile(src+".xml",dst+".xml")

class SshFold(LocalFold):
    def __init__(self, descriptor):
        self._base_init(descriptor)
        self.rpath = descriptor["rpath"]
        self.uname = descriptor["uname"]
        if(not self._check_mounted()):
            self._try_to_mount()
            if not self._check_mounted():
                ## trouble mounting remote
                from base_settings import base_settings
                bs = base_settings()
                self._log.write("SshFold", "can't mount remote %s:%s"%(self.ip, self.code), "ERR"); 
                bs.send_notify("SshFold: can't mount remote %s:%s"%(self.ip, self.code), "ERR"); 
                #reactor.stop()
        LocalFold.__init__(self, descriptor)

    def _check_mounted(self):
        f = open("/proc/mounts", "r")
        mpoint = f.readlines()
        f.close()
        for l in mpoint:
            if l.startswith("%s@%s:%s"%(self.uname, self.ip,self.rpath)):
                data = l.split(" ")
                if data[1] == self.path:
                    return True
        return False
                
    def _try_to_mount(self):
        try:
            temp = self.path
            if not os.path.exists(temp):
                os.makedirs(temp)
            self._log.write("SshFold", str(["sshfs", "%s@%s:%s"%(self.uname, self.ip, self.rpath), "%s"%(self.path)]), "INFO")
            subprocess.call(["sshfs", "%s@%s:%s"%(self.uname, self.ip, self.rpath), "%s"%(self.path)])
        except Exception, e:
            print "fico"


class originFactory(object):
    
    drivers = {
        "LocalFold" : LocalFold,
        "SshFold": SshFold,
        }
    
    @classmethod
    def allocateOrigin(cls, descriptor):
        t_selector = descriptor["type"]
        return cls.drivers[t_selector](descriptor)
