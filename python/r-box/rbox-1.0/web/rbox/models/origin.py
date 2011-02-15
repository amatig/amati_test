from django.db import models
from django.core.exceptions import ValidationError
from foldtype import Foldtype
import datetime
 
def validate_code(value):
    try:
        tmp = int(value)
    except:
        raise ValidationError(u'Enter a whole number.')
    if len(value) < 6:
        raise ValidationError(u'Code need a sequence of 6 numbers.')


class Origin(models.Model):
    code = models.CharField(max_length=6, primary_key=True, validators=[validate_code])
    label = models.CharField(max_length=255, unique=True)
    ip = models.IPAddressField()
    otype = models.ForeignKey(Foldtype)
    path = models.CharField(max_length=255)
    bc = models.PositiveIntegerField("Back check")
    tollerance = models.PositiveIntegerField()
    last_scan = models.DateTimeField("Creation datetime", default=datetime.datetime.min)
    removed = models.BooleanField()
    ## connection stuff
    uname = models.CharField(max_length=50, blank=True)
    passwd = models.CharField(max_length=50, blank=True)
    remote_path = models.CharField(max_length=255, blank=True)
    
    def need_rescan(self):
        days = self.tollerance/24
        hours = self.tollerance%24
        delta = datetime.datetime.now() - self.last_scan
        return not (delta.days<days or (delta.days==days and (delta.seconds/3600)<hours))
    
    def last_check(self):
        try:
            return str(int(self.registration_set.aggregate(models.Max('name'))["name__max"]))
        except Exception, e:
            return "None"
    
    def __unicode__(self):
        return "%s | %s" % (self.label, self.code)
    
    class Meta:
        app_label = 'rbox'
