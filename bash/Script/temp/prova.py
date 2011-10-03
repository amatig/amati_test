import urllib
import re

sock = urllib.urlopen("http://www.megaupload.com/es/?d=CYRIQKEL")
htmlSource = sock.read()
sock.close()

#patt = re.compile('"downloadlink">(.*)</div>')
#m = patt.search(htmlSource)
#print m

print htmlSource
