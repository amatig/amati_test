#from twisted.internet import reactor
from branching import branchManager
from rbox_log import rboxLog
import os, shutil, subprocess

class DLocalFold(object):
    
    def __init__(self, descriptor):
        self.code = descriptor["code"]
        self.path = descriptor["path"]
        self.ip = descriptor["ip"]
        
        self._log = rboxLog()
        
    def scan_repo(self, code):
        temp = os.sep.join([self.path, code])
        if not os.path.exists(temp):
            os.makedirs(temp)
        return self._scan_recursive(self.path, [code], -1)
    
    def _scan_recursive(self, base, l, deep):
        l.sort(lambda a,b: a>b and -1 or 1)
        if deep<3:
            for i in l:
                temp = os.sep.join([base, i])
                l1 = os.listdir(temp)
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
    
    def get_temp(self):
        return None
    
    def push(self, f_name, f_code):
        f = branchManager()
        f.set_path(f_code)
        try:
            os.makedirs(os.path.dirname(os.sep.join([self.path, f.get_abs_path("wav")])))
        except Exception,e:
            pass
        try:
            shutil.copyfile(f_name+".wav",os.sep.join([self.path, f.get_abs_tmp("wav")]))
            os.rename(os.sep.join([self.path, f.get_abs_tmp("wav")]),os.sep.join([self.path, f.get_abs_path("wav")]))
            
            shutil.copyfile(f_name+".xml",os.sep.join([self.path, f.get_abs_tmp("xml")]))
            os.rename(os.sep.join([self.path, f.get_abs_tmp("xml")]),os.sep.join([self.path, f.get_abs_path("xml")]))
        except Exception, e:
            self._log.write("DEST PUSH", e, "INFO")


class DSshFold(DLocalFold):
    def __init__(self, descriptor):
        DLocalFold.__init__(self, descriptor)
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
        except:
            print "popopop"
        try:
            self._log.write("sshfs %s@%s:%s %s"%(self.uname, self.ip, self.rpath, self.path), "INFO")
            subprocess.call(["sshfs", "%s@%s:%s"%(self.uname, self.ip, self.rpath), "%s"%(self.path)])
        except Exception, e:
            print "fottiti"
            print e
            print "fottiti2"
        
class destFactory(object):
    
    drivers = {
        "LocalFold" : DLocalFold,
        "SshFold" : DSshFold,
        }
    
    @classmethod
    def allocateDest(cls, descriptor):
        t_selector = descriptor["type"]
        return cls.drivers[t_selector](descriptor)
