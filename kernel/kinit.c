#include<xi/xi386.h>
#include<xi/video.h>
#include<stdint.h>
#include<string.h>
#include<stdio.h>

xi_state_t xi_state;

// TODO memory map struct
// TODO video info struct - for knowing h/w and bpp
__attribute__( ( section( "xi_kinit" ) ) ) void kinit( uint32_t* map_ptr, vbe_controller_info_t *vbe_controller_info, vbe_mode_info_t *vbe_mode_info ) {
	( void )map_ptr;

	xi_state.vbe_controller_info = vbe_controller_info;
	xi_state.vbe_mode_info = vbe_mode_info;
	xi_state.font = ( uint8_t* )0x11000;
	xi_state.mem_map = ( uint32_t* )map_ptr;

	clear( 0x000000ff );

	char test[] = "???\0";

	puts( test );

	while( 1 );
}
