#include <ruby.h>
#include <sofia-sip/nua.h>

static VALUE cApp;

/* c type */

typedef struct app_s
{
  su_home_t  home[1];  /* memory home */
  su_root_t* root;     /* root object */
  nua_t*     nua;      /* NUA stack object */
  int        num;      // test
} app_t;

/* application class */

static VALUE
cApp_new(VALUE class)
{
  VALUE info;

  /* alloc */
  app_t *context = ALLOC(app_t);
  //app_t context[1] = {{{{(sizeof context)}}}};

  info = Data_Wrap_Struct(class, 0, 0, context);  // 3th free pointer
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

void app_callback(nua_event_t   event,
                  int           status,
                  char const   *phrase,
                  nua_t        *nua,
                  nua_magic_t  *magic,
                  nua_handle_t *nh,
                  nua_hmagic_t *hmagic,
                  sip_t const  *sip,
                  tagi_t        tags[])
{

}

static VALUE
cApp_main_loop(VALUE self)
{
  app_t* context;
  Data_Get_Struct(self, app_t, context);

  if (context->root != NULL) {
    /* create NUA stack */
    context->nua = nua_create(context->root,
			      app_callback,
			      context,
			      /* tags as necessary ...*/
			      TAG_NULL());

    if (context->nua != NULL) {
      /* set necessary parameters */
      nua_set_params(context->nua,
		     /* tags as necessary ... */
		     TAG_NULL());

      /* enter main loop for processing of messages */
      su_root_run(context->root);

      /* destroy NUA stack */
      nua_destroy(context->nua);
    }

    /* deinit root object */
    su_root_destroy(context->root);
    context->root = NULL;
  }

  return Qnil;
}

static VALUE
cApp_shutdown(VALUE self)
{
  app_t* context;
  Data_Get_Struct(self, app_t, context);

  /* deinitialize memory handling */
  su_home_deinit(context->home);
  /* deinitialize system utilities */
  su_deinit();

  nua_shutdown(context->nua);

  return Qnil;
}

static VALUE
cApp_check(VALUE self)
{
  app_t* context;
  Data_Get_Struct(self, app_t, context);

  context->num = context->num + 3;
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
  rb_define_method(cApp, "shutdown", cApp_shutdown, 0);
  rb_define_method(cApp, "check", cApp_check, 0);
}
