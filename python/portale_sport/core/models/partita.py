from django.db import models
from django.forms import ModelForm
from sport import Sport

class Partita(models.Model):
    name = models.CharField(max_length=50)
    tipo = models.ForeignKey(Sport)
    giorno = models.DateField()
    ora = models.TimeField()
    campo = models.CharField(max_length=50)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = "core"


class PartitaForm(ModelForm):
    class Meta:
        model = Partita
