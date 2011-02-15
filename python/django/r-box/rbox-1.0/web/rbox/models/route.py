from django.db import models
from origin import Origin
from dest import Dest
import datetime

class Route(models.Model):
    label = models.CharField(max_length=255, unique=True)
    origin = models.ForeignKey(Origin)
    dest = models.ForeignKey(Dest)
    start = models.DateField("Start date", default=datetime.datetime.min)
    end = models.DateField("End date", default=datetime.date.max)
    rdate = models.DateTimeField("State datetime", default=datetime.datetime.min)
    state = models.PositiveIntegerField("state", default=0)
    removed = models.BooleanField()
    
    def __unicode__(self):
        return "%s | %s" % (self.label, self.pk)
    
    class Meta:
        app_label = 'rbox'
