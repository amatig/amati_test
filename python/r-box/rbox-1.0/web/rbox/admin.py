from django.contrib import admin
from models.setting import Setting
from models.origin import Origin
from models.dest import Dest
from models.registration import Registration
from models.route import Route
from models.schedule import Schedule
from models.foldtype import Foldtype
from models.previous import Previous
from models.logRecord import LogRecord
from models.schedule_move import ScheduleMove

class SettingAdmin(admin.ModelAdmin):
    list_display = ('name', 'value')
admin.site.register(Setting, SettingAdmin)

class PreviousAdmin(admin.ModelAdmin):
    list_display = ('first', 'last', 'dest')
admin.site.register(Previous, PreviousAdmin)

class OriginAdmin(admin.ModelAdmin):
    list_display = ('label', 'code', 'ip', 'otype', 'path', 'bc', 'tollerance', 'last_scan', 'removed')
admin.site.register(Origin, OriginAdmin)

class DestAdmin(admin.ModelAdmin):
    list_display = ('label', 'ip', 'dtype', 'path', 'removed')
admin.site.register(Dest, DestAdmin)

class RegistrationAdmin(admin.ModelAdmin):
    list_display = ('name', 'origin', 'cdt', 'xml_size', 'wav_size')
admin.site.register(Registration, RegistrationAdmin)

class RouteAdmin(admin.ModelAdmin):
    list_display = ('label', 'origin', 'dest', 'start', 'end', 'state', 'removed')
admin.site.register(Route, RouteAdmin)

class ScheduleAdmin(admin.ModelAdmin):
    list_display = ('route', 's_start', 's_end', 'force', 'last_run')
admin.site.register(Schedule, ScheduleAdmin)

class FoldtypeAdmin(admin.ModelAdmin):
    list_display = ('name', 'need_user', 'need_passwd', 'need_rpath')
admin.site.register(Foldtype, FoldtypeAdmin)

class LogRecordAdmin(admin.ModelAdmin):
    list_display = ('date', 'pid', 'level', 'msg')
admin.site.register(LogRecord, LogRecordAdmin)

class ScheduleMoveAdmin(admin.ModelAdmin):
    list_display = ('registration', 'route', 'sdate', 'state')
admin.site.register(ScheduleMove, ScheduleMoveAdmin)
