#include <sofia-sip/nua.h>

/* example of application context information structure */
typedef struct application
{
  su_home_t       home[1];  /* memory home */
  su_root_t      *root;     /* root object */
  nua_t          *nua;      /* NUA stack object */

  /* other data as needed ... */
} application;

/* Example of operation handle context information structure */
typedef union operation
{
  nua_handle_t    *handle;  /* operation handle */

  struct
  {
    nua_handle_t  *handle;  /* operation handle */
  } call;

  struct
  {
    nua_handle_t  *handle;  /* operation handle */
  } subscription;

/* other data as needed ... */

} operation;

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

int main(void)
{
  /* Application context structure */
  application appl[1] = {{{{(sizeof appl)}}}};

  /* initialize system utilities */
  su_init();

  /* initialize memory handling */
  su_home_init(appl->home);

  /* initialize root object */
  appl->root = su_root_create(appl);

  if (appl->root != NULL) {
    /* create NUA stack */
    appl->nua = nua_create(appl->root,
			   app_callback,
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

  /* deinitialize memory handling */
  su_home_deinit(appl->home);

  /* deinitialize system utilities */
  su_deinit();

  return 0;
}
