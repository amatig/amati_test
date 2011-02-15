from rbox.models.previous import Previous
from rbox.models.schedule_move import ScheduleMove
from rbox2.branching import branchManager
import os

class ArchiveManager(object):
    
    @classmethod
    def find_record(cls, name):
        return cls.find_record_history(name, True)
    
    @classmethod
    def find_record_history(cls, name, only_moved=False):
        data = {}
        try:
            lst1 = Previous.objects.filter(first__lte=name, last__gte=name)
            for e in lst1:
                data[e.dest.pk] = [name, "%s | %s" % (e.dest.label, e.dest.pk), e.dest.path, e.dest.remote_path, 2]
        except Exception, e:
            print e
        try:
            lst2 = []
            if only_moved:
                lst2 = ScheduleMove.objects.filter(registration__name=name, state=2)
            else:
                lst2 = ScheduleMove.objects.filter(registration__name=name)
            for e in lst2:
                data[e.route.dest.pk] = [name, "%s | %s" % (e.route.dest.label, e.route.dest.pk), e.route.dest.path, e.route.dest.remote_path, e.state]
        except Exception, e:
            print e
        return data.items()
    
    @classmethod
    def check_record(cls, name):
        lst = cls.find_record(name)
        print lst
        for e in lst:
            b = branchManager()
            b.set_path(e[1][0])
            temp = os.sep.join([e[1][2], b.get_abs_path("wav")])
            if os.path.exists(temp):
                return [200, temp]
        return [408, None]
