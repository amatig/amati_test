from django.forms import ModelForm
from core.models.partita import Partita

class PartitaForm(ModelForm):
    
    class Meta:
        model = Partita
