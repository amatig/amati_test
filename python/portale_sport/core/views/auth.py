from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth import authenticate, login, logout

from core.forms.login_form import LoginForm

def login_view(request):
    err1 = False
    err2 = False
    if request.method == "POST":
        next = request.POST["next"]
        form = LoginForm(request.POST)
        if form.is_valid():
            user = authenticate(username = request.POST["username"], password = request.POST["passwd"])
            if user is not None and user.is_active:
                login(request, user)
                return HttpResponseRedirect(next)
            else:
                err1 = True
                err2 = True
        else:
            err1 = True
    else:
        next = request.GET["next"]
        form = LoginForm()
    return render_to_response("login.html", {"form": form, "next": next, "err1": err1, "err2": err2}, RequestContext(request))

def logout_view(request):
    logout(request)
    return HttpResponseRedirect("/")
