from django.http import HttpResponse, HttpResponseRedirect
from django.template import RequestContext
from django.shortcuts import render_to_response

from core.models.partita import PartitaForm

def home(request):
    pageContext = {"title": "Pagina Principale"}
    return render_to_response("home.html", pageContext, RequestContext(request))

def partita(request):
    pageContext = {"title": "Nuova Partita"}
    if request.method == "POST":
        form = PartitaForm(request.POST)
        if form.is_valid():
            form.save()
    else:
        form = PartitaForm()
    pageContext.update({"form": form})
    return render_to_response("form.html", pageContext, RequestContext(request))
