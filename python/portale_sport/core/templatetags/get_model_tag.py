from django.template import Library, Node
from django.db.models import get_model

register = Library()

# si usa come {% get_latest core.Partita 5 as elemento %}
# core e' l'applicazione e Partita il model, prende il 5 elemento e lo mette in elemento nel contesto

class LatestContentNode(Node):
    
    def __init__(self, model, num, varname):
        self.num, self.varname = num, varname
        self.model = get_model(*model.split('.')) # ottieni un model da una stringa
    
    def render(self, context):
        # mette il risultato del contesto del templates durante la renderizzazione
        context[self.varname] = self.model._default_manager.all()[:self.num]
        return ''


def get_latest(parser, token):
    bits = token.contents.split()
    if len(bits) != 5: # check del numero esatto di argomenti
        raise TemplateSyntaxError, "get_latest tag takes exactly four arguments"
    if bits[3] != 'as': # as prima della variabile di contesto
        raise TemplateSyntaxError, "third argument to get_latest tag must be 'as'"
    return LatestContentNode(bits[1], bits[2], bits[4])
get_latest = register.tag(get_latest)
