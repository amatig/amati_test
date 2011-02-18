#include <ruby.h>
#include <sofia-sip/nua.h>

static VALUE cNua;
static VALUE cUrl;

static VALUE
cNua_initialize(VALUE self)
{
  return self;
}

static VALUE
cUrl_initialize(VALUE self)
{
  return self;
}

void
Init_sofia_sip()
{
  cUrl = rb_define_class("Url", rb_cObject);
  rb_define_method(cUrl, "initialize", cUrl_initialize, 0);

  cNua = rb_define_class("Nua", rb_cObject);
  rb_define_method(cNua, "initialize", cNua_initialize, 0);
}
