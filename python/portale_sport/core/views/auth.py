from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth import authenticate, login, logout

from core.forms.login_form import LoginForm
from django.contrib.auth.forms import UserCreationForm

def login(request):
    err = False
    if request.method == "POST":
        next = request.POST["next"]
        form = LoginForm(request.POST)
        if form.is_valid():
            user = authenticate(username = request.POST["username"], password = request.POST["passwd"])
            if user is not None and user.is_active:
                login(request, user)
                return HttpResponseRedirect(next)
            else:
                err = True
    else:
        next = request.GET["next"]
        form = LoginForm()
    return render_to_response("login.html", {"form": form, "next": next, "err": err}, RequestContext(request))

def logout(request):
    logout(request)
    return HttpResponseRedirect("/")

def register(request):
    pageContext = {"title": "Nuovo Utente"}
    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect("/")
    else:
        form = UserCreationForm()
    pageContext.update({"form": form})
    return render_to_response("form.html", pageContext, RequestContext(request))
