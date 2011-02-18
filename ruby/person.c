#include <utmp.h>
#include <ruby.h>

static VALUE mHuman; // module
static VALUE cPerson;

static VALUE
cPerson_initialize(VALUE self)
{
  VALUE name;

  name = Qnil;
  rb_iv_set(self, "@name", name);

  VALUE arr;

  arr = rb_ary_new();
  rb_iv_set(self, "@arr", arr);

  return self;
}

static VALUE cPerson_add(VALUE self, VALUE obj)
{
  VALUE arr;

  arr = rb_iv_get(self, "@arr");
  rb_ary_push(arr, obj);
  return arr;
}

void
Init_prova()
{
  mHuman = rb_define_module("Human");
  cPerson = rb_define_class_under(mHuman, "Person", rb_cObject);
  rb_define_method(cPerson, "initialize", cPerson_initialize, 0);
  rb_define_method(cPerson, "add", cPerson_add, 1);
}
