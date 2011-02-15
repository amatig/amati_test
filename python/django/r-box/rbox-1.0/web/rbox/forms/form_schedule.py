from django import forms
from rbox.models.schedule import Schedule

class PartialScheduleForm(forms.ModelForm):
    
    def clean_s_end(self):
        if self.cleaned_data.has_key("s_start") and self.cleaned_data['s_start'] > self.cleaned_data['s_end']:
            raise forms.ValidationError, "Start time greater than end time."
        return self.cleaned_data['s_end']
    
    class Meta:
        model = Schedule
        exclude = ('route', 'last_run')
