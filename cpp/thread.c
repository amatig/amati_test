#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

void *functionA(void *);
void *functionB(void *);

pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
int  counter = 0;

main()
{
  int rc1, rc2;
  pthread_t thread1, thread2;
  char *m1 = "uno";
  char *m2 = "due";
  
  /* Create independent threads each of which will execute functionC */

  if( (rc1=pthread_create( &thread1, NULL, functionA, (void *)m1)) )
    {
      printf("Thread creation failed: %d\n", rc1);
    }

  if( (rc2=pthread_create( &thread2, NULL, functionB, (void *)m2)) )
    {
      printf("Thread creation failed: %d\n", rc2);
    }

  /* Wait till threads are complete before main continues. Unless we  */
  /* wait we run the risk of executing an exit which will terminate   */
  /* the process and all threads before the threads have completed.   */
  
  void *ret1;
  void *ret2;
  
  pthread_join( thread1, &ret1);
  pthread_join( thread2, &ret2); 
    
  printf("1 returns: %d\n",(int)ret1);
  printf("2 returns: %d\n",(int)ret2);
  
  exit(0);
}

void *functionA(void *ptr)
{
  pid_t      pid = getpid();       /* ottengo il pid del processo */
  pthread_t  tid = pthread_self(); /* ottengo il tid del thread 
				      contenuto nel processo */

  char *message;
  message = (char *) ptr;
  
  for (int i = 0; i < 5; i++)
    {
      pthread_mutex_lock( &mutex1 );
      counter++;
      printf("THREAD %d 0x%x %s: %d\n", pid, tid, message, counter);
      pthread_mutex_unlock( &mutex1 );
      sleep(1);
    }
  pthread_exit((void *)1);
}

void *functionB(void *ptr)
{
  pid_t      pid = getpid();       /* ottengo il pid del processo */
  pthread_t  tid = pthread_self(); /* ottengo il tid del thread 
				      contenuto nel processo */

  char *message;
  message = (char *) ptr;
  
  for (int i = 0; i < 5; i++)
    {
      pthread_mutex_lock( &mutex1 );
      counter++;
      printf("THREAD %d 0x%x %s: %d\n", pid, tid, message, counter);
      pthread_mutex_unlock( &mutex1 );
      sleep(2);
    }
  pthread_exit((void *)0);
}
