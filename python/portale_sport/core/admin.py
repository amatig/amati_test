from django.contrib import admin
from models.sport import Sport
from models.partita import Partita
from models.struttura import Struttura

class SportAdmin(admin.ModelAdmin):
    list_display = ("name", )
admin.site.register(Sport, SportAdmin)

class StrutturaAdmin(admin.ModelAdmin):
    list_display = ("name", "sport")
admin.site.register(Struttura, StrutturaAdmin)

class PartitaAdmin(admin.ModelAdmin):
    pass
    #list_display = ("name", )
admin.site.register(Partita, PartitaAdmin)
