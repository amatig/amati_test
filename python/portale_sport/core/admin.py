from django.contrib import admin
from models.sport import Sport
from models.partita import Partita

class SportAdmin(admin.ModelAdmin):
    list_display = ("name", )
admin.site.register(Sport, SportAdmin)

class PartitaAdmin(admin.ModelAdmin):
    pass
    #list_display = ("name", )
admin.site.register(Partita, PartitaAdmin)
