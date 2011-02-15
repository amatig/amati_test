import os

class branchManager(object):
    
    def __init__(self):
        self.__path = "".zfill(15)
        self.code = 0    #6 digits
        self.level1 = 0  #3 digits
        self.level2 = 0  #2 digits
        self.level3 = 0  #2 digits
        self.leaf = 0    #2 digits
    
    def set_path(self, path):
        path = str(path)
        if path.__len__() == 15:
            self.__path = path
            self.code = int(path[0:6])
            self.level1 = int(path[6:9])
            self.level2 = int(path[9:11])
            self.level3 = int(path[11:13])
            self.leaf = int(path[13:15])
        elif path == 0:
            self.__path = "".zfill(15)
            self.set_code(0)
            self.set_level1(0)
            self.set_level2(0)
            self.set_level3(0)
            self.set_leaf(0)
    
    def get_code(self):
        return str(self.code).zfill(6)
    
    def set_code(self, code):
        c = str(code).zfill(6)
        if c.__len__() == 6:
            self.code = int(code)
            self.__path = c + self.__path[6:]
    
    def get_level1(self):
        return str(self.level1).zfill(3)
    
    def set_level1(self, code):
        c = str(code).zfill(3)
        if c.__len__() == 3:
            self.level1 = int(code)
            self.__path = self.__path[:6] + c + self.__path[9:]
    
    def get_level2(self):
        return str(self.level2).zfill(2)
    
    def set_level2(self, code):
        c = str(code).zfill(2)
        if c.__len__() == 2:
            self.level2 = int(code)
            self.__path = self.__path[:9] + c + self.__path[11:]
    
    def get_level3(self):
        return str(self.level3).zfill(2)
    
    def set_level3(self, code):
        c = str(code).zfill(2)
        if c.__len__() == 2:
            self.level3 = int(code)
            self.__path = self.__path[:11] + c + self.__path[13:]
    
    def get_leaf(self):
        return str(self.leaf).zfill(2)
    
    def set_leaf(self, code):
        c = str(code).zfill(2)
        if c.__len__() == 2:
            self.leaf = int(code)
            self.__path = self.__path[:13] + c + self.__path[15:]
    
    def get_path(self):
        return self.__path

    def get_abs_path(self, s=""):
        if s=="":
            return os.sep.join([self.get_code(), self.get_level1(), self.get_level2(), self.get_level3(), self.get_path()])
        else:
            return os.sep.join([self.get_code(), self.get_level1(), self.get_level2(), self.get_level3(), self.get_path()+"."+s])
        
    def get_abs_tmp(self, s=""):
        if s=="":
            return os.sep.join([self.get_code(), self.get_level1(), self.get_level2(), self.get_level3(), "."+self.get_path()])
        else:
            return os.sep.join([self.get_code(), self.get_level1(), self.get_level2(), self.get_level3(), "."+self.get_path()+"."+s])

    def min(self):
        return (self.get_code()).ljust(15,"0")
        
    def increment(self):
        if self.leaf < 99:
            self.set_leaf(self.leaf+1)
            return 0
        elif self.level3 < 99:
            self.set_level3(self.level3+1)
            self.set_leaf(0)
            return 0
        elif self.level2 < 99:
            self.set_level2(self.level2+1)
            self.set_level3(0)
            self.set_leaf(0)
            return 0
        elif self.level1 < 99:
            self.set_level1(self.level1+1)
            self.set_level2(0)
            self.set_level3(0)
            self.set_leaf(0)


if __name__=="__main__":
    path = "000000000000000.wav"
    a = branchManager()
    a.set_path(path)
    print a.get_code()
    print a.get_code()
    print a.get_level1()
    print a.get_path()
    a.set_level1(123)
    print a.get_path()
    a.set_level2(45)
    print a.get_path()
    a.set_level3(6)
    print a.get_path()
    a.set_leaf(99)
    print a.get_path()
