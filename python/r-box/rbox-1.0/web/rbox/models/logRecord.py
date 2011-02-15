from django.db import models
import datetime

class LogRecord(models.Model):
    date = models.DateTimeField("recording date", default=datetime.datetime.now)
    pid = models.CharField(max_length=255)
    level = models.IntegerField()
    msg = models.TextField()

    class Meta:
        app_label = 'rbox'
