from django.conf.urls.defaults import *
import views.index

urlpatterns = patterns('',
    # Example:
    # (r'^web/', include('web.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    (r'^$', views.index.home),
    (r'^login/*$', views.index.login_view),
    (r'^logout/*$', views.index.logout_view),
    (r'check/fold/([a-zA-Z0-9\ ]+)/*$', views.index.check_fold),
    (r'get/select1/*$', views.index.get_select1),
    (r'get/select2/*$', views.index.get_select2),
    (r'get/select3/*$', views.index.get_select3),
    (r'get/origin/*$', views.index.get_origin),
    (r'add/origin/*$', views.index.add_origin),
    (r'change/origin/(\d+)/*$', views.index.change_origin),
    (r'remove/origin/(\d+)/*$', views.index.remove_origin),
    (r'reset/origin/(\d+)/*$', views.index.reset_origin),
    (r'get/dest/*$', views.index.get_dest),
    (r'add/dest/*$', views.index.add_dest),
    (r'change/dest/(\d+)/*$', views.index.change_dest),
    (r'remove/dest/(\d+)/*$', views.index.remove_dest),
    (r'add/route/*$', views.index.add_route),
    (r'get/route/*$', views.index.get_route),
    (r'change/route/(\d+)/*$', views.index.change_route),
    (r'remove/route/(\d+)/*$', views.index.remove_route),
    (r'reset/route/(\d+)/*$', views.index.reset_route),
    (r'get/settings/*$', views.index.get_settings),
    (r'change/settings/(\w+)/*$', views.index.change_settings),
    (r'add/schedule/(\d+)/*$', views.index.add_schedule),
    (r'get/schedule/(\d+)/*$', views.index.get_schedule),
    (r'del/schedule/(\d+)/*$', views.index.del_schedule),
    (r'get/previous/*(\d*)/*$', views.index.get_previous),
    (r'add/previous/*$', views.index.add_previous),
    (r'del/previous/(\d+)/*$', views.index.del_previous),
    (r'get/notify/*(\d*)/*$', views.index.get_notify),
    (r'cleanall/notify/*$', views.index.cleanall_notify),
    (r'cleanpositive/notify/*$', views.index.cleanpositive_notify),
    (r'get/user/*(\d*)/*$', views.index.get_user),
    (r'add/user/*$', views.index.add_user),
    (r'edit/user/(\d+)/*$', views.index.edit_user),
    (r'del/user/(\d+)/*$', views.index.del_user),
    (r'search/record/(\w+)/*$', views.index.search_record),
)
