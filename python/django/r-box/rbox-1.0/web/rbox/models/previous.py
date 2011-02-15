from django.db import models
from django.core.exceptions import ValidationError
from dest import Dest

def validate_code(value):
    try:
        tmp = int(value)
    except:
        raise ValidationError(u'Enter a whole number.')
    if len(value) < 15:
        raise ValidationError(u'Filename need a sequence of 15 numbers.')


class Previous(models.Model):
    first = models.CharField("First filename", max_length=15, validators=[validate_code])
    last = models.CharField("Last filename", max_length=15, validators=[validate_code])
    dest = models.ForeignKey(Dest)
    manual = models.BooleanField(default=True)
    
    def __unicode__(self):
        return "%s - %s" % (self.first, self.last)
    
    class Meta:
        app_label = 'rbox'
        verbose_name = 'Previous History'
        verbose_name_plural = 'Previous History'
