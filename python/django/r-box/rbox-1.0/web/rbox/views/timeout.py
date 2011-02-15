from django.http import HttpResponse
import datetime, os

from rbox.models.setting import Setting
from rbox.models.route import Route
from rbox.models.schedule_move import ScheduleMove

def check_all(request):
    check_routes(request)
    check_schedule_moves(request)
    check_sysinfo(request)
    return HttpResponse("done")

def restore_route(r):
    r.state = 0
    r.rdate = datetime.datetime.now()
    r.save()

def check_routes(request):
    # minutes
    PENDING = 10
    UPDATING = 10
    SYNCING = 360
    
    lst = Route.objects.all()
    for r in lst:
        if r.state > 0:
            minutes, seconds = divmod((datetime.datetime.now() - r.rdate).seconds, 60)
            if r.state == 1 and minutes > PENDING:
                restore_route(r)
            elif r.state == 2 and minutes > UPDATING:
                restore_route(r)
            elif r.state == 3 and minutes > SYNCING:
                restore_route(r)
    return HttpResponse("done")

def restore_schedule_move(s):
    s.state = 0
    s.sdate = datetime.datetime.now()
    s.save()

def check_schedule_moves(request):
    # minutes
    PENDING = 15
    
    lst = ScheduleMove.objects.all()
    for s in lst:
        if s.state > 0:
            minutes, seconds = divmod((datetime.datetime.now() - s.sdate).seconds, 60)
            if s.state == 1 and minutes > PENDING:
                restore_schedule_move(s)
    return HttpResponse("done")

def check_sysinfo(request):
    s = Setting.objects.filter(name="SYSINFO.ssh-key")[0]
    if s:
        try:
            f = open(os.path.expanduser("~/.ssh/id_rsa.pub"))
            d = f.read()
            s.value = d
            f.close()
        except Exception,e :
            s.value = ""
        s.save()
    return HttpResponse("done")
