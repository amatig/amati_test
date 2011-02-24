#!/usr/bin/env python

from PyQt4.QtGui import *
from PyQt4.QtCore import *
from PyQt4.uic import loadUi
import sys

class Gui(QMainWindow):
    
    def __init__(self):
        QMainWindow.__init__(self)
        tree = loadUi("phone.ui", self)
        
        self.btn_call = tree.findChild(QPushButton, "btn_call")
        self.btn_answer = tree.findChild(QPushButton, "btn_answer")
        self.btn_bye = tree.findChild(QPushButton, "btn_bye")
        self.btn_reject = tree.findChild(QPushButton, "btn_reject")
        self.btn_hold = tree.findChild(QPushButton, "btn_hold")
        self.btn_transfer = tree.findChild(QPushButton, "btn_transfer")
        
        self.connect(self.btn_call, SIGNAL("clicked()"), self.btn_call_click)
        self.connect(self.btn_answer, SIGNAL("clicked()"), self.btn_answer_click)
        self.connect(self.btn_bye, SIGNAL("clicked()"), self.btn_bye_click)
        self.connect(self.btn_reject, SIGNAL("clicked()"), self.btn_reject_click)
        self.connect(self.btn_hold, SIGNAL("clicked()"), self.btn_hold_click)
        self.connect(self.btn_transfer, SIGNAL("clicked()"), self.btn_transfer_click)
        
        self.btn_call.setEnabled(False)
        self.btn_answer.setEnabled(False)
        self.btn_bye.setEnabled(False)
        self.btn_reject.setEnabled(False)
        self.btn_hold.setEnabled(False)
        self.btn_transfer.setEnabled(False)
        
        self.center()
                
        from phone_pjsip import PhonePJSIP
        PhonePJSIP()
        
    def center(self):
        screen = QDesktopWidget().screenGeometry()
        size = self.geometry()
        self.move((screen.width()-size.width())/2, (screen.height()-size.height())/2)
        
    def btn_call_click(self):
        print "1"
        
    def btn_answer_click(self):
        print "2"
        
    def btn_bye_click(self):
        print "3"
        
    def btn_reject_click(self):
        print "4"
        
    def btn_hold_click(self):
        print "5"
        
    def btn_transfer_click(self):
        print "6"
        
    def closeEvent(self, ev):
        print "quit"
        QMainWindow.closeEvent(self, ev)


def main(args):
    app = QApplication(args)
    window = Gui()
    window.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main(sys.argv)
