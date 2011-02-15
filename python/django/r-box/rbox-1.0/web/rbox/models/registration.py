from django.db import models
from origin import Origin

class Registration(models.Model):
    name = models.CharField(max_length=15, primary_key=True)
    origin = models.ForeignKey(Origin)
    cdt = models.DateTimeField("Creation datetime")
    xml_size = models.PositiveIntegerField()
    wav_size = models.PositiveIntegerField()
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = 'rbox'
