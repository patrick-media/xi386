#ifndef __xi_stdio
#define __xi_stdio

#include<xi/con.h>
#include<xi/xi386.h>
#include<string.h>

extern xi_state_t xi_state;

__attribute__( ( section( "xi_kinit" ) ) ) void putc( char c ) {
	_vga_con_putc( c, xi_state.vbe_mode_info, xi_state.font );
}

__attribute__( ( section( "xi_kinit" ) ) ) void puts( char *s ) {
	for( uint32_t i = 0; i < strlen( s ); i++ ) {
		putc( *( s + i ) );
	}
}

#endif // __xi_stdio
