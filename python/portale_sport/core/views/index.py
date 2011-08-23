from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.contrib.auth.decorators import login_required

from core.models.partita import Partita
from core.forms.partita_form import PartitaForm

@login_required
def home(request):
    pageContext = {"title": "Pagina Principale"}
    return render_to_response("home.html", pageContext, RequestContext(request))

@login_required
def list_partita(request):
    pageContext = {"title": "Prossime Partite"}
    pageContext.update({"list": Partita.objects.all()})
    return render_to_response("list.html", pageContext, RequestContext(request))

@login_required
def add_partita(request):
    pageContext = {"title": "Nuova Partita"}
    if request.method == "POST":
        form = PartitaForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect("/list/partita/")
    else:
        form = PartitaForm()
    pageContext.update({"form": form})
    return render_to_response("form.html", pageContext, RequestContext(request))
