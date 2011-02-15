from django import forms
from rbox.models.previous import Previous

class PreviousForm(forms.ModelForm):
    
    def clean_last(self):
        if self.cleaned_data.has_key("first") and self.cleaned_data.has_key("last") and \
                self.cleaned_data['first'] > self.cleaned_data['last']:
            raise forms.ValidationError, "First filename greater than last filename."
        return self.cleaned_data['last']
    
    class Meta:
        model = Previous

