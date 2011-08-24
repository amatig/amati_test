from django import forms
from django.contrib.auth.forms import UserCreationForm

class RegisterForm(UserCreationForm):
    first_name = forms.CharField(label = "Nome", max_length = 30)
    last_name = forms.CharField(label = "Cognome", max_length = 30)
    email = forms.CharField(label = "Email", max_length = 75)
    
    def save(self, commit = True):
        user = super(RegisterForm, self).save(commit = False)
        user.set_password(self.cleaned_data["password1"])
        user.first_name = self.cleaned_data["first_name"]
        user.last_name = self.cleaned_data["last_name"]
        user.email = self.cleaned_data["email"]
        if commit:
            user.save()
        return user
