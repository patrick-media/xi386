.code16

.extern vbe_setup

vbe_setup:
	movw $vesa_searching_for, %si
	call print

	movw (vesa_width), %dx // x res
	call print_hex16
	movw $0x0e20, %ax // space
	int $0x10

	movw (vesa_height), %dx // y res
	call print_hex16
	movw $0x0e20, %ax // space
	int $0x10

	xorw %dx, %dx
	movb (vesa_bpp), %dl // bits per pixel
	call print_hex16
	movw $0x0e0a, %ax // newline
	int $0x10
	movb $0xd, %al // carriage return
	int $0x10

	xorw %ax, %ax
	movw %ax, %es

	pushw %es
	movw $0x4f00, %ax
	movw $vbe_info_block, %di
	int $0x10
	popw %es

	cmpw $0x4f, %ax
	pushw $0x1
	jne .vbe_error1
	popw %ax

	movw (vbe_info_block.video_mode_ptr), %ax
	movw %ax, (vesa_offset)
	movw (vbe_info_block.video_mode_ptr+2), %ax
	movw %ax, (vesa_segment)

	movw %ax, %fs
	movw (vesa_offset), %si

.find_mode:
	movw %fs:(%si), %dx
	incw %si
	incw %si
	movw %si, (vesa_offset)
	movw %dx, (vesa_mode)

	cmpw $0xffff, %dx
	je .end_of_modes

	pushw %es
	movw $0x4f01, %ax
	movw (vesa_mode), %cx
	movw $mode_info_block, %di
	int $0x10
	popw %es

	cmpw $0x4f, %ax
	pushw $0x2
	jne .vbe_error2
	popw %ax

	movw $vesa_found, %si
	call print

	movw (mode_info_block.x_resolution), %dx
	call print_hex16
	movw $0x0e20, %ax // space
	int $0x10

	movw (mode_info_block.y_resolution), %dx
	call print_hex16
	movw $0x0e20, %ax // space
	int $0x10

	movb (mode_info_block.bpp), %dl
	xorb %dh, %dh
	call print_hex16
	movw $0x0e0a, %ax // newline
	int $0x10
	movb $0x0d, %al // carriage return
	int $0x10

	movw (vesa_width), %ax
	cmpw (mode_info_block.x_resolution), %ax
	jne .next_mode

	movw (vesa_height), %ax
	cmpw (mode_info_block.y_resolution), %ax
	jne .next_mode

	movb (vesa_bpp), %al
	cmpb (mode_info_block.bpp), %al
	jne .next_mode

	pushw %es
	movw $0x4f02, %ax
	movw (vesa_mode), %bx
	orw $0x4000, %bx
	xorw %di, %di
	int $0x10
	popw %es

	cmpw $0x4f, %ax
	pushw $0x3
	jne .vbe_error3
	popw %ax

	ret

.next_mode:
	movw (vesa_segment), %ax
	movw %ax, %fs
	movw (vesa_offset), %si
	jmp .find_mode

.vbe_error1:
	popw %gs
	jmp .vbe_error_comm
.vbe_error2:
	popw %gs
	jmp .vbe_error_comm
.vbe_error3:
	popw %gs
	jmp .vbe_error_comm
.vbe_error_comm:
	movw $vesa_fail, %si
	call print
	movw %ax, %dx
	call print_hex16
	jmp vesa_hang

.end_of_modes:
	movw $vesa_eom, %si
	call print
vesa_hang:
	jmp vesa_hang


/* VESA Data */
// github.com/queso-fuego/amateuros/blob/master/src/2ndstage.asm

vesa_width: .word 0
vesa_height: .word 0
vesa_bpp: .byte 0
vesa_offset: .word 0
vesa_segment: .word 0
vesa_mode: .word 0

vesa_searching_for: .asciz 	"[  VBE  ] Searching for: "
vesa_found: .asciz		"[  VBE  ] Found: "
vesa_fail: .asciz		"[  VBE  ] Failed (check GS): AX = "
vesa_eom: .asciz		"[  VBE  ] Failed: specified mode not found."
