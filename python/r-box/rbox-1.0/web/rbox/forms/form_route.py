from django import forms
from rbox.models.route import Route

class RouteForm(forms.ModelForm):
    
    def clean_end(self):
        if self.cleaned_data['start'] > self.cleaned_data['end']:
            raise forms.ValidationError, "Start date greater than end date."
        return self.cleaned_data['end']
    
    class Meta:
        model = Route
        exclude = ('state', 'rdate')

class NewRouteForm(forms.ModelForm):
    
    def clean_end(self):
        if self.cleaned_data['start'] > self.cleaned_data['end']:
            raise forms.ValidationError, "Start date greater than end date."
        return self.cleaned_data['end']
    
    class Meta:
        model = Route
