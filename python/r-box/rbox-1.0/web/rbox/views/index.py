from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth.decorators import login_required
from django.contrib.auth import authenticate, login, logout
from django.core import serializers
from django.utils import simplejson
import unicodedata, datetime, math

from django.contrib.auth.models import User
from rbox.models.foldtype import Foldtype
from rbox.models.previous import Previous
from rbox.models.logRecord import LogRecord
from rbox.models.origin import Origin
from rbox.models.dest import Dest
from rbox.models.route import Route
from rbox.models.schedule import Schedule
from rbox.models.setting import Setting
from rbox.forms.form_origin import OriginForm, NewOriginForm
from rbox.forms.form_dest import DestForm
from rbox.forms.form_route import RouteForm, NewRouteForm
from rbox.forms.form_schedule import PartialScheduleForm
from rbox.forms.form_previous import PreviousForm
from rbox.forms.form_login import LoginForm
from rbox.forms.form_user import UserForm, EditUserForm

from django.core.exceptions import PermissionDenied

from rbox.libs.archive_manager import ArchiveManager

def superuser_only(function):
    def _inner(request, *args, **kwargs):
        if not request.user.is_superuser:
            raise PermissionDenied           
        return function(request, *args, **kwargs)
    return _inner

def home(request):
    pageContext = {"title": "Home"}
    if not request.user.is_authenticated():
        pageContext.update({"l_label": "Login"})
    else:
        pageContext.update({"l_label": "Logout"})        
    return render_to_response("index.html", pageContext, RequestContext(request))

def login_view(request):
    err = False
    err2 = False
    if request.method == "POST":
        form = LoginForm(request.POST)
        if form.is_valid():
            user = authenticate(username=request.POST['username'], password=request.POST['passwd'])
            if user is not None and user.is_active:
                login(request, user)
            else:
                err2 = True
                err = True
        else:
            err = True
    else:
        form = LoginForm()
    return render_to_response("login.html", {"err2": err2, "err": err, "form": form}, RequestContext(request))

def logout_view(request):
    logout(request)
    return HttpResponse("", mimetype="application/json")

@login_required
def check_fold(request, label):
    o = Foldtype.objects.get(pk=label)
    data = serializers.serialize("json", [o])
    return HttpResponse(data, mimetype="application/json")

@login_required
def search_record(request, c):
    data = []
    if len(c) == 15:
        data = ArchiveManager.find_record_history(c)
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_select1(request):
    data = []
    sel = None
    if request.POST.has_key("sel"):
        sel = request.POST["sel"]
    lst = Foldtype.objects.all()
    for o in lst:
        data.append([o.name, o.name, sel == o.name and 1 or 0])
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_select2(request):
    data = []
    sel = None
    if request.POST.has_key("sel"):
        sel = request.POST["sel"]
    for o in Origin.objects.all():
        data.append([o.pk, "%s | %s" % (o.label, o.pk), sel == "%s | %s" % (o.label, o.pk) and 1 or 0])
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_select3(request):
    data = []
    sel = None
    if request.POST.has_key("sel"):
        sel = request.POST["sel"]
    for o in Dest.objects.all():
        data.append([o.pk, "%s | %s" % (o.label, o.pk), sel == "%s | %s" % (o.label, o.pk) and 1 or 0])
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_previous(request, p = 0):
    if not p:
        p = 0
    p = int(p)
    n4page = 30
    
    lst = Previous.objects.filter(manual=True).order_by("id")[p * n4page :p * n4page + n4page]
    count = Previous.objects.filter(manual=True).count()
    
    data = []
    for e in lst:
        try:
            data.append({"pk": e.pk, 
                         "fields": {"first": e.first,
                                    "last": e.last,
                                    "dest": "%s | %s" % (e.dest.label, e.dest.pk)},
                         "count": math.ceil(float(count) / float(n4page)) - 1})
        except:
            pass
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@superuser_only
def get_user(request, p = 0):
    if not p:
        p = 0
    p = int(p)
    n4page = 30
    
    lst = User.objects.filter(is_staff=False).order_by("id")[p * n4page :p * n4page + n4page]
    count = User.objects.filter(is_staff=False).count()
    
    data = []
    for e in lst:
        try:
            data.append({"pk": e.pk, 
                         "fields": {"username": e.username,
                                    "is_superuser": e.is_superuser},
                         "count": math.ceil(float(count) / float(n4page)) - 1})
        except:
            pass
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_notify(request, p = 0):
    if not p:
        p = 0
    p = int(p)
    n4page = 30
    
    lst = LogRecord.objects.all().order_by("-date")[p * n4page :p * n4page + n4page]
    count = LogRecord.objects.all().count()
    
    data = []
    for e in lst:
        try:
            data.append({"pk": e.pk, 
                         "fields": {"date": str(e.date),
                                    "pid": e.pid,
                                    "level": e.level,
                                    "msg": e.msg},
                         "count": math.ceil(float(count) / float(n4page)) - 1})
        except:
            pass
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_origin(request):
    lst = Origin.objects.all().order_by("label")
    data = serializers.serialize("json", lst)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_dest(request):
    lst = Dest.objects.all().order_by("label")
    data = serializers.serialize("json", lst)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_route(request):
    data = []
    lst = Route.objects.all().order_by("label")
    
    for e in lst:
        try:
            data.append({"pk": e.pk, 
                         "fields": {"origin": "%s | %s" % (e.origin.label, e.origin.pk), 
                                    "dest": "%s | %s" % (e.dest.label, e.dest.pk), 
                                    "label": e.label, 
                                    "start": str(e.start), 
                                    "end": str(e.end), 
                                    "state": e.state, 
                                    "rdate": str(e.rdate), 
                                    "removed": e.removed,
                                    "stat_sched": "%s/%s" % (e.schedule_set.filter(last_run=datetime.datetime.now).count(), e.schedule_set.all().count()),
                                    "stat_to_move": e.schedulemove_set.filter(state=0).count(),
                                    "stat_errs": e.schedulemove_set.filter(state=1).count(),
                                    "stat_done": e.schedulemove_set.filter(state=2).count()}})
        except:
            pass
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_schedule(request, r):
    lst = Schedule.objects.filter(route=r).order_by("s_start")
    for e in lst:
        h = int(e.s_end.strftime("%H"))
        m = int(e.s_end.strftime("%M"))
        if m > 0:
            h += 1
            m = 0
        if h > 23:
            h = 23
            m = 59
        e.s_end = datetime.time(h, m, 0)
    data = serializers.serialize("json", lst)
    return HttpResponse(data, mimetype="application/json")

@login_required
def get_settings(request):
    data = {}
    lst = Setting.objects.all().order_by("name")
    for e in lst:
        cx = e.name.split(".")
        if len(cx) < 2:
            continue
        if not data.has_key(cx[0]):
            data[cx[0]] = []
        data[cx[0]].append({"name": cx[1], "value": e.value, "description": e.description, "editable": e.editable})
    data = simplejson.dumps(data)
    return HttpResponse(data, mimetype="application/json")

@login_required
def reset_origin(request, c):
    o = Origin.objects.get(code=c)
    if o:
        o.last_scan = datetime.datetime.min
        o.save()
    return HttpResponse("", mimetype="application/json")

@login_required
def reset_route(request, code):
    r = Route.objects.get(pk=code)
    r.state = 0
    r.save()
    s = Schedule.objects.filter(route=r, 
                                s_start__lt=datetime.datetime.now().time())[0]
    if s:
        s.last_run = datetime.datetime.min
        s.save()
    return HttpResponse("", mimetype="application/json")

@login_required
def remove_origin(request, c):
    o = Origin.objects.get(code=c)
    o.removed = not o.removed
    o.save()
    lst = o.route_set.all()
    for r in lst:
        r.removed = o.removed and o.removed or r.removed
        r.save()
    return HttpResponse("", mimetype="application/json")

@login_required
def remove_dest(request, c):
    o = Dest.objects.get(pk=c)
    o.removed = not o.removed
    o.save()
    return HttpResponse("", mimetype="application/json")

@login_required
def remove_route(request, c):
    o = Route.objects.get(pk=c)
    o.removed = not o.removed
    o.save()
    return HttpResponse("", mimetype="application/json")

@login_required
def cleanall_notify(request):
    try:
        LogRecord.objects.all().delete()
    except:
        pass
    return HttpResponse("", mimetype="application/json")

@login_required
def cleanpositive_notify(request):
    try:
        LogRecord.objects.filter(level__gte=0).delete()
    except:
        pass
    return HttpResponse("", mimetype="application/json")

@login_required
def del_previous(request, c):
    try:
        o = Previous.objects.get(pk=c)
        o.delete()
    except:
        pass
    return HttpResponse("", mimetype="application/json")

@superuser_only
def del_user(request, c):
    try:
        o = User.objects.get(pk=c)
        o.delete()
    except:
        pass
    return HttpResponse("", mimetype="application/json")

@login_required
def add_previous(request):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"first": request.POST["first"],
                    "last": request.POST["last"],
                    "dest": request.POST["dest"],
                    "manual": True}
        except:
            pass
        form = PreviousForm(data)
        if form.is_valid():
            form.save()
        else:
            err =True
    else:
        form = PreviousForm()
    
    return render_to_response("previous.html", {"err": err, "form": form}, RequestContext(request))

@superuser_only
def add_user(request):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"username": request.POST["username"],
                    "password": request.POST["password"],
                    "is_active": True,
                    "is_superuser": request.POST["is_superuser"],
                    "last_login": datetime.datetime.min,
                    "date_joined": datetime.datetime.now()}
        except:
            pass
        form = UserForm(data)
        if form.is_valid():
            o = form.save(commit=False)
            o.set_password(o.password)
            o.save()
        else:
            err =True
    else:
        form = UserForm()
    
    return render_to_response("user.html", {"err": err, "form": form}, RequestContext(request))

@superuser_only
def edit_user(request, c):
    obj = User.objects.get(pk=c)
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"password": request.POST["password"],
                    "is_active": True,
                    "is_superuser": request.POST["is_superuser"],
                    "last_login": obj.last_login,
                    "date_joined": obj.date_joined}
        except:
            pass
        
        old_passwd = obj.password
        form = EditUserForm(data, instance=obj)
        if form.is_valid():
            try:
                o = form.save(commit=False)
                if o.password != old_passwd:
                    o.set_password(data["password"])
                o.save()
            except:
                pass
        else:
            err =True
    else:
        form = EditUserForm(instance=obj)
    
    return render_to_response("user.html", {"pk": obj.pk, "err": err, "form": form}, RequestContext(request))

@login_required
def add_origin(request):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"label": request.POST["label"],
                    "code": request.POST["code"],
                    "ip": request.POST["ip"],
                    "otype": request.POST["otype"],
                    "path": request.POST["path"],
                    "bc": request.POST["bc"],
                    "tollerance": request.POST["tollerance"],
                    "last_scan": datetime.datetime.min}
        except:
            pass
        form = NewOriginForm(data)
        if form.is_valid():
            form.save()
        else:
            err =True
    else:
        form = NewOriginForm()
    
    return render_to_response("origin.html", {"err": err, "form": form}, RequestContext(request))

@login_required
def add_dest(request):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"label": request.POST["label"],
                    "ip": request.POST["ip"],
                    "dtype": request.POST["dtype"],
                    "path": request.POST["path"]}
        except:
            pass
        form = DestForm(data)
        if form.is_valid():
            form.save()
        else:
            err =True
    else:
        form = DestForm()
    return render_to_response("dest.html", {"err": err, "form": form}, RequestContext(request))

@login_required
def add_route(request):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"label": request.POST["label"],
                    "origin": request.POST["origin"],
                    "dest": request.POST["dest"],
                    "start": request.POST["start"],
                    "end": request.POST["end"],
                    "state": 0,
                    "s_start": request.POST["s_start"],
                    "s_end": request.POST["s_end"],
                    "force": request.POST["force"],
                    "rdate": datetime.datetime.min}
        except:
            pass
        
        form = NewRouteForm(data)
        form2 = PartialScheduleForm(data)
        if form.is_valid() and form2.is_valid():
            try:
                route = form.save()
                sched = form2.save(commit=False)
                sched.route = route
                sched.save()
            except:
                pass
        else:
            err =True
    else:
        form = NewRouteForm()
        form2 = PartialScheduleForm()
    
    return render_to_response("route.html", {"err": err, "form": form, "form2": form2}, RequestContext(request))

@login_required
def add_schedule(request, c):
    err = False
    if request.method == 'POST':
        data = {}
        try:
            data = {"s_start": request.POST["s_start"],
                    "s_end": request.POST["s_end"],
                    "force": request.POST["force"],
                    "rdate": datetime.datetime.min}
        except:
            pass
        form = PartialScheduleForm(data)
        if form.is_valid():
            try:
                sched = form.save(commit=False)
                sched.route = Route.objects.get(pk=c)
                sched.save()
            except:
                pass
        else:
            err =True
    else:
        form = PartialScheduleForm()
    
    return render_to_response("sched.html", {"pk": c, "err": err, "form": form}, RequestContext(request))

@login_required
def del_schedule(request, c):
    lst = []
    if request.method == 'POST':
        for k in request.POST:
            if k.startswith("v_"):
                s = Schedule.objects.get(pk=request.POST[k])
                s.delete()
    else:
        lst = Schedule.objects.filter(route=c)        
    return render_to_response("del_sched.html", {"pk": c, "list": lst}, RequestContext(request))

@login_required
def change_origin(request, code):
    result = {}
    obj = Origin.objects.get(pk=code)
    if obj:
        data = {}
        if request.method == 'POST':
            try:
                data = {"label": request.POST["label"],
                        "ip": request.POST["ip"],
                        "otype": request.POST["otype"],
                        "path": request.POST["path"],
                        "bc": request.POST["bc"],
                        "tollerance": request.POST["tollerance"]}
                if request.POST.has_key("uname"):
                    data["uname"] = request.POST["uname"]
                if request.POST.has_key("passwd"):
                    data["passwd"] = request.POST["passwd"]
                if request.POST.has_key("remote_path"):
                    data["remote_path"] = request.POST["remote_path"]
            except:
                pass
        form = OriginForm(data, instance=obj)
        if form.is_valid():
            obj.label = data["label"]
            obj.ip = data["ip"]
            obj.otype.pk = data["otype"]
            obj.path = data["path"]
            obj.bc = data["bc"]
            obj.tollerance = data["tollerance"]
            if data.has_key("uname"):
                obj.uname = data["uname"]
            if data.has_key("passwd"):
                obj.passwd = data["passwd"]
            if data.has_key("remote_path"):
                obj.remote_path = data["remote_path"]
            obj.save()
            result.update({"result": "success"})
        else:
            temp = []
            for k, v in form.errors.items():
                vvv = unicodedata.normalize('NFKD', v[0]).encode('ascii', 'ignore')
                temp.append({"key": k, "value": vvv})
            result.update({"result": temp})
    
    result = simplejson.dumps(result)
    return HttpResponse(result, mimetype="application/json")

@login_required
def change_dest(request, code):
    result = {}
    obj = Dest.objects.get(pk=code)
    if obj:
        data = {}
        if request.method == 'POST':
            try:
                data = {"label": request.POST["label"],
                        "ip": request.POST["ip"],
                        "dtype": request.POST["dtype"],
                        "path": request.POST["path"]}
                if request.POST.has_key("uname"):
                    data["uname"] = request.POST["uname"]
                if request.POST.has_key("passwd"):
                    data["passwd"] = request.POST["passwd"]
                if request.POST.has_key("remote_path"):
                    data["remote_path"] = request.POST["remote_path"]
            except:
                pass
        form = DestForm(data, instance=obj)
        if form.is_valid():
            obj.label = data["label"]
            obj.ip = data["ip"]
            obj.dtype.pk = data["dtype"]
            obj.path = data["path"]
            if data.has_key("uname"):
                obj.uname = data["uname"]
            if data.has_key("passwd"):
                obj.passwd = data["passwd"]
            if data.has_key("remote_path"):
                obj.remote_path = data["remote_path"]
            obj.save()
            result.update({"result": "success"})
        else:
            temp = []
            for k, v in form.errors.items():
                vvv = unicodedata.normalize('NFKD', v[0]).encode('ascii', 'ignore')
                temp.append({"key": k, "value": vvv})
            result.update({"result": temp})
    
    result = simplejson.dumps(result)
    return HttpResponse(result, mimetype="application/json")

@login_required
def change_route(request, code):
    result = {}
    obj = Route.objects.get(pk=code)
    if obj:
        data = {}
        if request.method == 'POST':
            try:
                data = {"label": request.POST["label"],
                        "origin": request.POST["origin"],
                        "dest": request.POST["dest"],
                        "start": request.POST["start"],
                        "end": request.POST["end"]}
            except:
                pass
        form = RouteForm(data, instance=obj)
        try:
            if form.is_valid():
                try:
                    obj.label = data["label"]
                    obj.origin.pk = data["origin"]
                    obj.dest.pk = data["dest"]
                    obj.start = data["start"]
                    obj.end = data["end"]
                    obj.save()
                except:
                    pass
                result.update({"result": "success"})
            else:
                temp = []
                for k, v in form.errors.items():
                    vvv = unicodedata.normalize('NFKD', v[0]).encode('ascii', 'ignore')
                    temp.append({"key": k, "value": vvv})
                result.update({"result": temp})
        except:
            result.update({"result": "success"})
    
    result = simplejson.dumps(result)
    return HttpResponse(result, mimetype="application/json")

@login_required
def change_settings(request, cx):
    result = {}
    if request.method == 'POST':
        lst = Setting.objects.filter(name__startswith = cx)
        for e in lst:
            try:
                if e.editable:
                    e.value = request.POST[e.name.split(".")[1]]
                    e.save()
            except:
                pass
    
    result.update({"result": "success"})
    result = simplejson.dumps(result)
    return HttpResponse(result, mimetype="application/json")
