from django.http import HttpResponse
from django.db import transaction
from rbox.models.setting import Setting
from rbox.models.origin import Origin
from rbox.models.dest import Dest
from rbox.models.schedule import Schedule
from rbox.models.schedule_move import ScheduleMove
from rbox.models.registration import Registration
from rbox.models.route import Route
from rbox.models.logRecord import LogRecord

from django.core.exceptions import ObjectDoesNotExist
from django.core.mail import send_mail
from xml.marshal import *
import datetime

def get_settings(request):
    all_s = Setting.objects.all()
    output = {}
    for setting in all_s:
        tmp = setting.name
        context = str(tmp[:tmp.find('.')])
        name = str(tmp[tmp.find('.')+1:])
        if not output.has_key(context):
            output[context] = {}
        output[context][name] = str(setting.value)
    result = generic.dumps(output)
    return HttpResponse(result ,mimetype="application/xml", status=200)

def get_origin(request, obj):
    output = {}
    try:
        origin = Origin.objects.get(pk=str(obj))
    except ObjectDoesNotExist:
        result = generic.dumps(output)
        return HttpResponse(result ,mimetype="application/xml", status=200)
    except Exception, e:
        print type(e)
    try:
        output["code"] = str(origin.code)
        output["ip"] = str(origin.ip)
        output["type"] = str(origin.otype)
        output["path"] = str(origin.path)
        output["uname"] = str(origin.uname)
        output["passwd"] = str(origin.passwd)
        output["rpath"] = str(origin.remote_path)
        output["bc"] = origin.bc
        output["to_be_check"] = origin.need_rescan() and 1 or 0
        output["last_known"] = origin.last_check()
    except Exception,e:
        print e
    result = generic.dumps(output)
    return HttpResponse(result ,mimetype="application/xml", status=200)

def get_dest(request, obj):
    output = {}
    try:
        dest = Dest.objects.get(pk=str(obj))
    except ObjectDoesNotExist:
        result = generic.dumps(output)
        return HttpResponse(result ,mimetype="application/xml", status=200)
    except Exception, e:
        print type(e)
    try:
        output["code"]= str(dest.id)
        output["ip"] = str(dest.ip)
        output["type"] = str(dest.dtype)
        output["path"] = str(dest.path)
        output["uname"] = str(dest.uname)
        output["passwd"] = str(dest.passwd)
        output["rpath"] = str(dest.remote_path)
    except Exception,e:
        print e
    result = generic.dumps(output)
    return HttpResponse(result ,mimetype="application/xml", status=200)

def get_activity(request):
    output = {}
    l = Schedule.objects.filter(route__state=0, 
                                s_start__lt=datetime.datetime.now().time(), 
                                last_run__lt=datetime.date.today(),
                                ).exclude(route__removed=True)
    # limitare la query a priory al primo elemento, magari fare l'ordinamento su time boh
    if l.__len__()==0:
        result = generic.dumps(output)
        return HttpResponse(result ,mimetype="application/xml", status=200)
    try:
        output["route"] = str(l[0].route.pk)
        output["origin"] = str(l[0].route.origin.pk)
        output["dest"] = str(l[0].route.dest.pk)
        output["endtime"] = 0
        if l[0].force:
            output["endtime"] = l[0].end_time
        # chage route state
        if l[0].route.state < 1:
            l[0].route.state = 1
            l[0].route.rdate = datetime.datetime.now()
            l[0].route.save()
        l[0].last_run = datetime.date.today()
        l[0].save()
    except Exception, e:
        print e
    result = generic.dumps(output)
    return HttpResponse(result ,mimetype="application/xml", status=200)

def done_activity(request, code):
    try:
        r = Route.objects.get(pk=code)
        r.state = 0
        r.rdate = datetime.datetime.now()
        r.save()
    except Exception, e:
        print e
    return HttpResponse("", mimetype="application/xml", status=200)

@transaction.autocommit
def deliver_recheck_records(request):
    if request.method == 'POST':
        dat  = generic.loads(request.POST["data"])
        code = None
        for k in dat.keys():
            if code == None:
                code = Origin.objects.get(pk=k[:6])
            try:
                r = Registration.objects.get(name = k)
                if r.xml_size != int(dat[k]["xml_size"]) or r.wav_size != int(dat[k]["wav_size"]):
                    r.xml_size = int(dat[k]["xml_size"])
                    r.wav_size = int(dat[k]["wav_size"])
                    r.save()
                    s = r.schedulemove_set.all()
                    print s
                    for m in s:
                        if m.route.state == 1:
                            # chage route state
                            m.route.state = 2
                            m.route.rdate = datetime.datetime.now()
                            m.route.save()
                        # chage schedule move state
                        m.state = 0
                        m.sdate = datetime.datetime.now()
                        m.save()
            except Exception, e:
                transaction.rollback()
                print "cazzo"
                print e
    return HttpResponse("" ,mimetype="application/xml", status=200)

@transaction.commit_manually
def deliver_new_records(request):
    transaction.commit()
    if request.method == 'POST':
        dat  = generic.loads(request.POST["data"])
        code = None
        for k in dat.keys():
            if code == None:
                code = Origin.objects.get(pk=k[:6])
            try:
                Registration.objects.create(name = k,
                                            origin = code,
                                            cdt = datetime.datetime.fromtimestamp(int(dat[k]["wav_time"])),
                                            xml_size = int(dat[k]["xml_size"]),
                                            wav_size = int(dat[k]["wav_size"]))
                temp = Route.objects.filter(origin=code)
                for m in temp:
                    if m.state == 1:
                        # chage route state
                        m.state = 2
                        m.rdate = datetime.datetime.now()
                        m.save()
            except Exception, e:
                transaction.rollback()
                print "cazzo"
                print e
        transaction.commit()
    return HttpResponse("" ,mimetype="application/xml", status=200)

@transaction.commit_manually
def deliver_confirm_records(request):
    transaction.commit()
    if request.method == 'POST':
        dat  = generic.loads(request.POST["data"])
        for k in dat:
            try:
                s = ScheduleMove.objects.get(pk=k)
                if s.state < 2:
                    # chage route state
                    s.state = 2
                    s.sdate = datetime.datetime.now()
                    s.save()
            except Exception, e:
                transaction.rollback()
                print "error confirm"
                print e
        transaction.commit()
    return HttpResponse("" ,mimetype="application/xml", status=200)

def rescan_complete(request, code):
    o = Origin.objects.get(pk=code)
    o.last_scan = datetime.datetime.now()
    o.save()
    return HttpResponse("" ,mimetype="application/xml", status=200)

@transaction.commit_manually
def get_schedule(request, route):
    NoW = datetime.datetime.now()
    segment = 500
    result=[]
    try:
        r = Route.objects.get(pk=route)
        schedules = r.schedulemove_set.filter(state=0)[:segment]
        results=[]
        for s in schedules:
            if s.route.state < 3:
                # chage route state
                s.route.state = 3
                s.route.rdate = NoW
                s.route.save()
            if s.state < 1:
                # chage schedule move state
                s.state = 1
                s.sdate = NoW
                s.save()
            results.append((s.pk,str(s.registration.name)))
        transaction.commit()
        result = generic.dumps(results)
    except:
        print "doh"
        transaction.rollback()
    return HttpResponse(result ,mimetype="application/xml", status=200)

def set_notify(request, pid):
    if request.method == 'POST':
        dat  = generic.loads(request.POST["data"])
        l = LogRecord()
        l.pid = "%s:%s" % (request.META['REMOTE_ADDR'], pid)
        l.level = int(dat["level"])
        l.msg = dat["msg"]
        l.save()
        
        msg = "Notify level: %s\n\nIP/PID: %s\n\nMessage: %s\n" % (l.level, l.pid, l.msg)
        email = Setting.objects.get(name="NOTIFY.email")
        if email:
            send_mail('R-Box Notify', msg, 'rbox_notifier@noreply.it', [email.value], fail_silently=True)
    return HttpResponse("done")
