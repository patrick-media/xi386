#ifndef __xi_video
#define __xi_video

#include<stdint.h>
#include<xi/xi386.h>
#include<xi/vesa.h>

extern xi_state_t xi_state;

__attribute__( ( section( "xi_kinit" ) ) ) void clear( uint32_t color ) {
	uint16_t xres = xi_state.vbe_mode_info->x_resolution;
	uint16_t yres = xi_state.vbe_mode_info->y_resolution;
	uint8_t bypp = xi_state.vbe_mode_info->bpp / 8; // bytes per pixel
	for( uint32_t i = 0; i < xres * yres * bypp; i += bypp ) {
		*( ( uint32_t* )( xi_state.vbe_mode_info->physical_base_ptr + i ) ) = color;
	}
}

#endif // __xi_video
