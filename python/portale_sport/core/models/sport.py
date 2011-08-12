from django.db import models

class Sport(models.Model):
    name = models.CharField(max_length=50)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = "core"
