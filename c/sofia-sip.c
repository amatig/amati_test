#include <ruby.h>
#include <sofia-sip/nua.h>

/* c type */

typedef struct app_s
{
  su_home_t       home[1];  /* memory home */
  su_root_t      *root;     /* root object */
  nua_t          *nua;      /* NUA stack object */
  int num;                  // test
} app_t;

/* application class */

static VALUE cApp;

static VALUE
cApp_new(VALUE class)
{
  VALUE info;

  /* alloc */
  //app_t context[1] = {{{{(sizeof context)}}}};
  app_t *context = ALLOC(app_t);

  info = Data_Wrap_Struct(class, 0, 0, context);
  rb_obj_call_init(info, 0, 0);
  return info;
}

static VALUE
cApp_initialize(VALUE self)
{
  app_t* context;
  Data_Get_Struct(self, app_t, context);

  /* initialize system utilities */
  su_init();
  /* initialize memory handling */
  su_home_init(context->home);
  /* initialize root object */
  context->root = su_root_create(context);
  /* test */
  context->num = 1;

  return self;
}

static VALUE
cApp_main_loop(VALUE self)
{
  VALUE info;
  app_t* appl;

  Data_Get_Struct(self, app_t, appl);

  if (appl->root != NULL) {
    /* create NUA stack */
    appl->nua = nua_create(appl->root,
			   NULL, // app_callback
			   appl,
			   /* tags as necessary ...*/
			   TAG_NULL());

    if (appl->nua != NULL) {
      /* set necessary parameters */
      nua_set_params(appl->nua,
		     /* tags as necessary ... */
		     TAG_NULL());

      /* enter main loop for processing of messages */
      su_root_run(appl->root);

      /* destroy NUA stack */
      nua_destroy(appl->nua);
    }

    /* deinit root object */
    su_root_destroy(appl->root);
    appl->root = NULL;
  }
}

static VALUE
cApp_check(VALUE self)
{
  app_t* context;

  Data_Get_Struct(self, app_t, context);
  return rb_int_new(context->num);
}

/* sofia_sip init */

void
Init_sofia_sip()
{
  cApp = rb_define_class("App", rb_cObject);
  rb_define_singleton_method(cApp, "new", cApp_new, 0);
  rb_define_method(cApp, "initialize", cApp_initialize, 0);
  rb_define_method(cApp, "main_loop", cApp_main_loop, 0);
  rb_define_method(cApp, "check", cApp_check, 0);
}
