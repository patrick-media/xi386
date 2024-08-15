#ifndef __xi_vesa
#define __xi_vesa

#include<stdint.h>

typedef struct {
	char signature[ 4 ];
	uint16_t version;
	uint32_t oem_str_ptr;
	uint32_t capabilities;
	uint32_t video_mode_ptr;
	uint16_t total_mem;
	uint16_t oem_software_rev;
	uint32_t oem_vendor_name_ptr;
	uint32_t oem_product_name_ptr;
	uint32_t oem_product_rev_ptr;
	uint8_t reserved[ 222 ];
	uint8_t oem_data[ 256 ];
} vbe_controller_info_t __attribute__( ( packed ) );

typedef struct {
	uint16_t mode_attrib;
	uint8_t window_a_attrib;
	uint8_t window_b_attrib;
	uint16_t window_granularity;
	uint16_t window_size;
	uint16_t window_a_seg;
	uint16_t window_b_seg;
	uint32_t window_function_ptr;
	uint16_t bytes_per_scanline;

	// VBE 1.2
	uint16_t x_resolution;
	uint16_t y_resolution;
	uint8_t x_charsize;
	uint8_t y_charsize;
	uint8_t num_planes;
	uint8_t bpp;
	uint8_t num_banks;
	uint8_t mem_model;
	uint8_t bank_size;
	uint8_t num_image_pages;
	uint8_t reserved1;

	// Direct color fields
	uint8_t red_mask_size;
	uint8_t red_field_position;
	uint8_t green_mask_size;
	uint8_t green_field_position;
	uint8_t blue_mask_size;
	uint8_t blue_field_position;
	uint8_t reserved_mask_size;
	uint8_t reserved_field_position;
	uint8_t direct_color_mode_info;
	
	// VBE 2.0
	uint32_t physical_base_ptr;
	uint32_t reserved2;
	uint16_t reserved3;

	// VBE 3.0
	uint16_t linear_bytes_per_scan_line;
	uint8_t bank_num_image_pages;
	uint8_t linear_num_image_pages;
	uint8_t linear_red_mask_size;
	uint8_t linear_red_field_position;
	uint8_t linear_green_mask_size;
	uint8_t linear_green_field_position;
	uint8_t linear_blue_mask_size;
	uint8_t linear_blue_field_position;
	uint8_t linear_reserved_mask_size;
	uint8_t linear_reserved_field_position;
	uint32_t max_pixel_clock;
	uint8_t reserved4[ 190 ];
} vbe_mode_info_t __attribute__( ( packed ) );

#endif // __xi_vesa
