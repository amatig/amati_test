from django.conf.urls.defaults import *
import views.timeout

urlpatterns = patterns('',
    # Example:
    # (r'^web/', include('web.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    
    (r'check/all/*', views.timeout.check_all), # fa tutte le viste sotto
    
    (r'check/routes/*', views.timeout.check_routes),
    (r'check/setting/*', views.timeout.check_sysinfo),
    (r'check/schedule/moves/*', views.timeout.check_schedule_moves),
)
