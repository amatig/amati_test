from django.forms import ModelForm
from rbox.models.dest import Dest

class DestForm(ModelForm):
    class Meta:
        model = Dest
