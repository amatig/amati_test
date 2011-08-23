from django import template

register = template.Library()

class ProfileNode(template.Node):
    
    def __init__(self):
        pass
    
    def render(self, context):
        t = template.loader.get_template("profile.html")
        return t.render(template.Context(context, autoescape = context.autoescape))


def user_profile(parser, token):
    return ProfileNode()
user_profile = register.tag(user_profile)
