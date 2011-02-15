from django.db import models

class Setting(models.Model):
    name = models.CharField(max_length=25, primary_key=True)
    value = models.TextField()
    editable = models.BooleanField(default=True)
    description = models.TextField(blank=True)
    
    def __unicode__(self):
        return self.name
    
    class Meta:
        app_label = 'rbox'
