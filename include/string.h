#ifndef __xi_string
#define __xi_string

__attribute__( ( section( "xi_kinit" ) ) ) size_t strlen( const char *s ) {
	size_t len = 0;
	while( *s++ ) {
		len++;
	}
	return len;
}

#endif // __xi_string
