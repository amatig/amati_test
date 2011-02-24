from stack_interface import StackInterface

class Pjsip(StackInterface):
    
    def __init__(self):
        print "init classe"
    
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
