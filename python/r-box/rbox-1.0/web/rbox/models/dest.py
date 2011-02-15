from django.db import models
from foldtype import Foldtype

class Dest(models.Model):
    label = models.CharField(max_length=255, unique=True)
    ip = models.IPAddressField()
    dtype = models.ForeignKey(Foldtype)
    path = models.CharField(max_length=255)
    removed = models.BooleanField()
    ## connection stuff
    uname = models.CharField(max_length=50, blank=True)
    passwd = models.CharField(max_length=50, blank=True)
    remote_path = models.CharField(max_length=255, blank=True)
    
    def __unicode__(self):
        return "%s | %s" % (self.label, self.pk)
    
    class Meta:
        app_label = 'rbox'
