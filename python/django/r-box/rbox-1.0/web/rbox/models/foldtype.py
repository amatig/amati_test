from django.db import models

class Foldtype(models.Model):
    name = models.CharField(max_length=30, primary_key=True)
    need_user = models.BooleanField(default=False)
    need_passwd = models.BooleanField(default=False)
    need_rpath = models.BooleanField(default=False)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = 'rbox'
