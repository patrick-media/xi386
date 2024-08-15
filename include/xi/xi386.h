#ifndef __xi386
#define __xi386

#include<xi/vesa.h>

typedef struct {
	vbe_controller_info_t *vbe_controller_info;
	vbe_mode_info_t *vbe_mode_info;
	uint8_t *font;
	uint32_t *mem_map;
} xi_state_t __attribute__( ( packed ) );

#endif // __xi386
