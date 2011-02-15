from django.conf.urls.defaults import *
import views.rest

urlpatterns = patterns('',
    # Example:
    # (r'^web/', include('web.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'schedule/done/(\d+)/', views.rest.done_activity),
    (r'schedule/next/', views.rest.get_activity),
    (r'schedule/list/(\d+)/', views.rest.get_schedule),
    (r'basic/settings/', views.rest.get_settings),
    (r'origin/(\d{6})/', views.rest.get_origin),
    (r'origin/scan/done/(\d{6})/', views.rest.rescan_complete),
    (r'dest/(\d+)/', views.rest.get_dest),
    (r'notify/(\d+)/', views.rest.set_notify),
    (r'records/deliver/', views.rest.deliver_new_records),
    (r'records/recheck/', views.rest.deliver_recheck_records),
    (r'records/confirm/', views.rest.deliver_confirm_records),
)
