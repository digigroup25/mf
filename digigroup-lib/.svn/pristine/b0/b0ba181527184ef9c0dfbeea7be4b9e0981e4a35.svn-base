from django.conf.urls.defaults import patterns, include, url
from django.conf import settings

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),

    (r'^gateway', 'maps.amfgateway.myGateway'),

    #(r'^hello', 'main.views.hello'),

    (r'^(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT}),
    # Examples:

#    (r'^gateway', 'main.amfgateway.myGateway'),
    
#    url(r'^$', 'main.amfgateway.myGateway'),

#    (r'^hello', 'main.views.hello'),

#    url(r'^vtm/$', 'django.views.generic.simple.direct_to_template', {'template': 'vtm.html'}),
    # url(r'^vtm/', include('vtm.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    #url(r'^admin/', include(admin.site.urls)),

)
