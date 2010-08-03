#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.61])
AC_INIT([irc_bot], [0.1], [amatig@gmail.com])

AC_CONFIG_SRCDIR([src/main.cpp])
AC_CONFIG_HEADERS([config.h])

AM_INIT_AUTOMAKE([1.10])

# Checks for programs.
AC_PROG_CXX

# Checks for libraries.

AC_ARG_ENABLE(pthread,
	[--disable-pthread pthread support (default enable).],
	[PTHREAD="$enableval"],
	[PTHREAD="yes"])

if test "$PTHREAD" = "yes"; then
   AC_DEFINE(POSIX_MULTITHREAD_SUPPORT, 1,
   [Define to 1 to build with pthreads support (--enable-pthreads)])
   AC_DEFINE(_REENTRANT, 1,
   [Define _REENTRANT for several plaforms])
   AC_CHECK_LIB(pthreads, pthread_create, [],
   [AC_CHECK_LIB(pthread, pthread_create)])
   AC_CHECK_FUNCS(localtime_r strtok_r strerror_r pthread_mutexattr_settype)
   if test x"$ac_cv_func_pthread_mutexattr_settype" = xyes; then
      AC_TRY_COMPILE([#include <pthread.h>],
      [ int i = PTHREAD_MUTEX_RECURSIVE;],
      [AC_DEFINE(PG_RECURSIVE_MUTEXATTR, PTHREAD_MUTEX_RECURSIVE,
      [Define if you have PTHREAD_MUTEX_RECURSIVE])], [
      AC_TRY_COMPILE([#include <pthread.h>],
      [ int i = PTHREAD_MUTEX_RECURSIVE_NP;],
      [AC_DEFINE(PG_RECURSIVE_MUTEXATTR, PTHREAD_MUTEX_RECURSIVE_NP,
      [Define if you have PTHREAD_MUTEX_RECURSIVE_NP])])])
  fi
fi

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([src/Makefile])
AC_OUTPUT