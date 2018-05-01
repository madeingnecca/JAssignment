#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

int ok = 1;

int no_errors() {
	return ok ? EXIT_SUCCESS : EXIT_FAILURE;
}


/* stampa sullo stderr una stringa del tipo procname:errorcode:cause[NEWLINE] */
/* cause contiene una stringa formato printf */
void test_error( char* procname,
                 char* errorcode,
                 char* cause, ... ) {
  
  va_list params;
  va_start(params, cause);  

  fprintf( stderr, "%s:%s:", procname, errorcode );
  vfprintf( stderr, cause, params );
  fprintf( stderr, "\n" );

  va_end(params);
  
  ok = 0; /* segnalo errore avvenuto */
}
