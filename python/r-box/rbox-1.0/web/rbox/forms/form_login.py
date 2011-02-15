from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(max_length=100)
    passwd = forms.CharField("Password", widget=forms.PasswordInput(render_value=False))
