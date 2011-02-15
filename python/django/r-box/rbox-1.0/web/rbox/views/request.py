from django.http import HttpResponse
from rbox.libs.archive_manager import ArchiveManager

def playback(request):
    uid = None
    r = [408, None]
    
    if request.method == "GET":
        if request.GET.has_key("uid"):
            uid = request.GET["uid"]
    else:
        if request.GET.has_key("uid"): # prendere uid dalla HEAD non GET
            uid = request.GET["uid"]
    
    if uid:
        r = ArchiveManager.check_record(uid)
        if request.method == "GET" and r[0] == 200:
            return HttpResponse(open(r[1], "rb").read(), mimetype="audio/wav")
    
    return HttpResponse(status = r[0])
