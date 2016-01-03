from django.contrib import admin

from maps.models import *


class MapAdmin(admin.ModelAdmin):
    list_display = ['owner', 'name']


class UserMapAdmin(admin.ModelAdmin):
    list_display = ['user', 'map']
    
admin.site.register(Map, MapAdmin)
admin.site.register(UserMap, UserMapAdmin)