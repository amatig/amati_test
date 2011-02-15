#from xml.marshal import *
from twisted.internet import reactor
#from twisted.web import client
from base_settings import base_settings


http_serv = "localhost"
http_port = 8080


if __name__=="__main__":
    bs = base_settings(http_serv, http_port)
    reactor.run()
