from django.db import models
from route import Route
import datetime

class Schedule(models.Model):
    route = models.ForeignKey(Route, blank=True, null=True)
    s_start = models.TimeField("Start time")
    s_end = models.TimeField("End time", default=datetime.datetime.max)
    force = models.BooleanField("Force exit", help_text = "Force exit to end time.")
    last_run = models.DateField(default=datetime.datetime.min);
    
    class Meta:
        app_label = 'rbox'
