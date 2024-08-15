/* <sector 3> (2 sectors) */

// TODO load less sectors initially (and in lower memory - load file table & stage 2 at 0x1000 or something and load kernel from there)
// TODO write linker scripts & finish configuring all these files (& figure out .include nonsense)

/* Stage 2 */
/* @func stage2
 * @desc Second stage of the bootloader.
 */
stage2:
	movb $0x0f, %bh			/* White on black */
	call scr_reset

	movw $0x0706, %cx
	call scr_set_cursor_style	/* Hidden */


	// TODO start page: resolution selection
	// bios ascii codes: ascii-codes.com


	pushw $0x0
	popw %es

	xorw %bx, %bx			/* First page */
	movw $0x080d, %dx		/* 8th row, 13th column (y, x) */
	call scr_set_cursor_pos

	movw $xi386_logo, %si
	call print

	movw $0x1600, %dx
	call scr_set_cursor_pos		/* 10th row, 0th column */
	
	movw $s2_f10, %si
	call print
	movw $s2_f11, %si
	call print
	movw $s2_f12, %si
	call print

	movw $1920, (vesa_width)
	movw $1080, (vesa_height)
	movb $32, (vesa_bpp)

	movw $0x65, %cx

poll_keys:
	movw (0x46c), %dx
	incw %dx
.poll_keys_inner:
	movb $0x1, %ah			/* Function set (query keyboard status, int 0x16) */
	int $0x16			/* ah = scancode, al = ASCII code */
	jz .keys_skip

	movb $0x0, %ah
	int $0x16

	cmpb $0x44, %ah			// F10
	//je set_safe_mode
	cmpb $0x85, %ah			// F11
	//je change_resolution
	cmpb $0x86, %ah			// F12
	je terminal

.keys_skip:
	cmpw (0x46c), %dx
	jne .poll_keys_inner

	decw %cx
	cmpw $0x0, %cx
	je pre32

	jmp poll_keys

pre32:
	movb $0x0f, %bh
	call scr_reset

	xorw %bx, %bx
	xorw %dx, %dx
	call scr_set_cursor_pos

	call get_mem_map

	call print_mem_map

.hang:	jmp .hang

	call vbe_setup

	jmp setup32
	

	// TODO real mode terminal, change res dialog, safe mode
	// TODO filesystem?, ACIA driver?

	// 32-bit mode coming - see init32

.include "boot/stdinit.s"
.include "boot/stdscr.s"

.data
/*
 * Stage 2 Data
 */
xi386_logo: .asciz "ooooooo  ooooo  o8o    .oooo.    .ooooo.       .ooo\n              `8888    d8'   `\"'  .dP\"\"Y88b  d88'   `8.   .88'\n                Y888..8P    oooo        ]8P' Y88..  .8'  d88'\n                 `8888'     `888      <88b.   `88888b.  d888P\"Ybo.\n                .8PY888.     888       `88b. .8'  ``88b Y88[   ]88\n               d8'  `888b    888  o.   .88P  `8.   .88P `Y88   88P\n             o888o  o88888o o888o `8bd88P'    `boood8'   `88bod8'"
s2_f10: .asciz		"                                                                F10 - Safe Mode\n"
s2_f11: .asciz		"                                                        F11 - Change Resolution\n"
s2_f12: .asciz		"                                                       F12 - Real Mode Terminal\n"
space: .asciz		" "
newline: .asciz		"\n"

.text

. = stage2 + 1023
.byte 0x00
/* </sector 4> (2 sectors) */

/* <sector 5> */
.include "boot/vesa.s"
.include "boot/mem.s"
/* </sector 5> */

/* <sector 6> (2 sectors) */
.include "boot/vesa_data.s"
/* </sector 7> (2 sectors) */


/* <sector 8> */
boot_services:

.include "boot/terminal.s"
. = boot_services + 512 /* TODO terminal should handle its own sector size management */
/* </sector 8> */

/* <sector 9> */
/* @func setup32
 * @desc Begin setting up for 32-bit protected mode.
 */
setup32:
	cli
	movl %cr0, %eax
	orl $0x1, %eax	/* Enable protected mode flag */
	movl %eax, %cr0

	lgdt gdtp
	movw $(gdt_data - gdt_start), %ax
	movw %ax, %ds
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	movw %ax, %ss
	movl $0x3000, %esp

	movl $vbe_info_block, %esi
	movl $0x5000, %edi
	movl $128, %ecx
	rep movsl

	movl $mode_info_block, %esi
	movl $0x5200, %edi
	movl $64, %ecx
	rep movsl

	ljmp $0x8, $init32

.data

.include "boot/gdt.s"

.text

.code32
/* @func init32
 * @desc Initial 32-bit function for protected mode.
 */
init32: // WORKING - setup more in 16-bit mode before coming here tho
	/*
	movl (0x5028), %edi
	movl $1920*1080, %ecx
	movl $0x000000ff, %eax
	rep stosl
	*/

	pushl $0x5200		// VBE mode info block address
	pushl $0x5000		// VBE info block address
	pushl $mem_map_entries	// Memory map table address

	call kinit

.end32:	jmp .end32

. = setup32 + 511
.byte 0xff
/* </sector 9> */
