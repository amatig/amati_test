from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(label = "Nome utente", max_length = 30)
    passwd = forms.CharField(label = "Password", widget = forms.PasswordInput)
    next = forms.CharField(max_length = 255)
