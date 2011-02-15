from django.forms import ModelForm
from rbox.models.origin import Origin

class OriginForm(ModelForm):
    class Meta:
        model = Origin
        exclude = ('code', 'last_scan')

class NewOriginForm(ModelForm):
    class Meta:
        model = Origin
