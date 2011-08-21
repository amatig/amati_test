from django.conf.urls.defaults import patterns, include, url

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    url(r'^$', 'core.views.index.home'),
    url(r'^accounts/login/*$', 'core.views.auth.login_view'),
    url(r'^logout/*$', 'core.views.auth.logout_view'),
    url(r'^list/partita/$', 'core.views.index.list_partita'),
    url(r'^add/partita/$', 'core.views.index.add_partita'),
    # url(r'^portale_sport/', include('portale_sport.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^admin/', include(admin.site.urls)),
)
