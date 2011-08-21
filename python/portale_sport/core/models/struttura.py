from django.db import models
from sport import Sport

class Struttura(models.Model):
    name = models.CharField(max_length=50)
    sport = models.ForeignKey(Sport)
    indirizzo = models.CharField(max_length=100)
    telefono = models.CharField(max_length=50)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = "core"
        verbose_name_plural = "Strutture"
