from django.db import models
from sport import Sport
from struttura import Struttura

class Partita(models.Model):
    name = models.CharField(max_length=50)
    tipo = models.ForeignKey(Sport)
    giorno = models.DateField()
    ora = models.TimeField()
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = "core"
        verbose_name_plural = "Partita"
