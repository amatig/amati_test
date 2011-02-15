from django.db import models
from registration import Registration
from route import Route
from django.db.models import signals
import datetime

class ScheduleMove(models.Model):
    registration = models.ForeignKey(Registration)
    route = models.ForeignKey(Route)
    sdate = models.DateTimeField("Scheduling datetime")
    state = models.IntegerField()
    
    class Meta:
        app_label = 'rbox'
        unique_together = (('registration', 'route'),)


def add_registration_callback(sender, **kwargs):
    t = datetime.date.today()
    reg = kwargs["instance"]
    route = reg.origin.route_set.filter(start__lte=t).filter(end__gte=t)
    if kwargs["created"] == True:
        for r in route:
            reg.schedulemove_set.create(route = r,
                                        sdate = datetime.datetime.now(),
                                        state = 0)
    ## manage 

def add_route_callback(sender, **kwargs):
    new_route = kwargs["instance"]
    t = datetime.datetime(new_route.start.year,
                          new_route.start.month, 
                          new_route.start.day )
    if kwargs["created"] == True:
        reg = new_route.origin.registration_set.filter(cdt__gte=t)
        for r in reg:
            new_route.schedulemove_set.create(registration = r,
                                              sdate = datetime.datetime.now(),
                                              state = 0)

signals.post_save.connect(add_registration_callback, sender=Registration, dispatch_uid="rbox.models.schedule_move.add_registration")
signals.post_save.connect(add_route_callback, sender=Route, dispatch_uid="rbox.models.schedule_move.add_route")
