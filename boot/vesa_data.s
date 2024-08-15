vbe_info_block:
	vbe_info_block.signature: .ascii "VBE2"
	vbe_info_block.version: .word 0
	vbe_info_block.oem_string_ptr: .long 0
	vbe_info_block.capabilities: .long 0
	vbe_info_block.video_mode_ptr: .long 0
	vbe_info_block.total_mem: .word 0
	vbe_info_block.oem_software_rev: .word 0
	vbe_info_block.oem_vendor_name_ptr: .long 0
	vbe_info_block.oem_product_name_ptr: .long 0
	vbe_info_block.oem_product_rev_ptr: .long 0
	vbe_info_block.reserved: .fill 222, 0
	vbe_info_block.oem_data: .fill 256, 0

/* SECTOR BREAK */
. = vbe_info_block + 512

mode_info_block:
	mode_info_block.mode_attrib: .word 0
	mode_info_block.window_a_attrib: .byte 0
	mode_info_block.window_b_attrib: .byte 0
	mode_info_block.window_granularity: .word 0
	mode_info_block.window_size: .word 0
	mode_info_block.window_a_seg: .word 0
	mode_info_block.window_b_seg: .word 0
	mode_info_block.window_function_ptr: .long 0
	mode_info_block.bytes_per_scanline: .word 0

	// VBE 1.2
	mode_info_block.x_resolution: .word 0
	mode_info_block.y_resolution: .word 0
	mode_info_block.x_charsize: .byte 0
	mode_info_block.y_charsize: .byte 0
	mode_info_block.num_planes: .byte 0
	mode_info_block.bpp: .byte 0
	mode_info_block.num_banks: .byte 0
	mode_info_block.mem_model: .byte 0
	mode_info_block.bank_size: .byte 0
	mode_info_block.num_image_pages: .byte 0
	mode_info_block.reserved1: .byte 1

	// Direct color fields
	mode_info_block.red_mask_size: .byte 0
	mode_info_block.red_field_position: .byte 0
	mode_info_block.green_mask_size: .byte 0
	mode_info_block.green_field_position: .byte 0
	mode_info_block.blue_mask_size: .byte 0
	mode_info_block.blue_field_position: .byte 0
	mode_info_block.reserved_mask_size: .byte 0
	mode_info_block.reserved_field_position: .byte 0
	mode_info_block.direct_color_mode_info: .byte 0

	// VBE 2.0
	mode_info_block.physical_base_ptr: .long 0
	mode_info_block.reserved2: .long 0
	mode_info_block.reserved3: .word 0

	// VBE 3.0
	mode_info_block.linear_bytes_per_scan_line: .word 0
	mode_info_block.bank_num_image_pages: .byte 0
	mode_info_block.linear_num_image_pages: .byte 0
	mode_info_block.linear_red_mask_size: .byte 0
	mode_info_block.linear_red_field_position: .byte 0
	mode_info_block.linear_green_mask_size: .byte 0
	mode_info_block.linear_green_field_position: .byte 0
	mode_info_block.linear_blue_mask_size: .byte 0
	mode_info_block.linear_blue_field_position: .byte 0
	mode_info_block.linear_reserved_mask_size: .byte 0
	mode_info_block.linear_reserved_field_position: .byte 0
	mode_info_block.max_pixel_clock: .long 0
	mode_info_block.reserved4: .fill 190, 0
. = mode_info_block + 511
.byte 0x00
