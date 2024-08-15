#ifndef __xi_con
#define __xi_con

__attribute__( ( section( "xi_kinit" ) ) ) void _vga_con_putc( char c, vbe_mode_info_t *vbe_mode_info, uint8_t *font ) {
	static uint8_t cursor_x = 0;
	static uint8_t cursor_y = 0;

	uint32_t x_max = 8;
	uint32_t y_max = 16;

	uint8_t bypp = vbe_mode_info->bpp / 8; // bytes per pixel

	for( uint8_t y = 0; y < y_max; y++ ) {
		for( uint8_t x = 0; x < x_max; x++ ) {
			// Making this readable is not my job; it works. -Patrick 7/24/24
			*( ( uint32_t* )( vbe_mode_info->physical_base_ptr + x*bypp + y*vbe_mode_info->x_resolution*bypp + cursor_x*x_max*bypp + cursor_y*y_max*vbe_mode_info->x_resolution*bypp ) ) = font[ y + c*16 ] & ( 0x80 >> x ) ? 0xffffffff : 0x000000ff;
		}
	}

	cursor_x++;

	if( cursor_x > 239 ) {
		cursor_x = 0;
		cursor_y++;
	}
}

#endif // __xi_con
