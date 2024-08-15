.code16

.extern print
.extern print_color
.extern print_hex8
.extern print_hex16
.extern print_hex32

/* @func print 
 * @desc Print a string using BIOS INT 10H.
 * @param str [si] : string to print
 */
print:
	pusha
	movb $0x0e, %ah
.pinner:
	lodsb

	cmpb $0, %al
	je .preturn
	cmpb $0x0a, %al
	je .pnewline

	int $0x10
	jmp .pinner
.preturn:
	popa
	ret
.pnewline:
	pushw %ax
	pushw %bx

	xorw %bx, %bx	/* Page 0 */
	pushw %cx	/* Don't need cursor style (returned by scr_get_cursor_attr) */
	call scr_get_cursor_attr
	popw %cx

	incb %dh	/* Next row (c, r+1) */
	xorb %dl, %dl	/* Reset columns (0, r) */
	call scr_set_cursor_pos

	popw %bx
	popw %ax
	jmp .pinner	/* Byte wasn't 0, return to printing */

/* @func print_color
 * @desc Print a string using BIOS INT 10H with a color attribute.
 * @param str [si] : string to print
 * @param attr [bl] : attribute to print characters in
 */
print_color:
	pusha
	movw $0x1, %cx	/* Print character once */
	movb $0x9, %ah
.pcinner:
	lodsb

	cmpb $0, %al
	je .pcreturn
	cmpb $0x0a, %al
	je .pcnewline

	int $0x10

	pushw %bx
	pushw %cx
	xorw %bx, %bx
	call scr_get_cursor_attr
	popw %cx
	popw %bx

	incb %dl
	cmpb $0x50, %dl		/* 0x50 = 80 */
	jge .pcnewline

	pushw %bx
	xorw %bx, %bx
	call scr_set_cursor_pos
	popw %bx

	jmp .pcinner
.pcreturn:
	popa
	ret
.pcnewline:
	pushw %ax
	pushw %bx

	xorw %bx, %bx	/* See above for comments */
	pushw %cx
	call scr_get_cursor_attr
	popw %cx

	incb %dh
	xorb %dl, %dl
	call scr_set_cursor_pos

	popw %bx
	popw %ax
	jmp .pcinner

/* @func print_hex8/16/32
 * @desc Print 8/16/32-bit hexadecimal values to the screen (github.com/queso-fuego/amateuros/blob/master/src/2ndstage.asm - adapted to 8/32 bits)
 * @param num [(e)dx/dl] : number to print in hexadecimal
 */
print_hex8:
	pusha
	movw $0x2, %cx
	movw $hex_string8, %di
	jmp .hex_loop_pre
print_hex16:
	pusha
	movw $0x4, %cx
	movw $hex_string16, %di
	jmp .hex_loop_pre
print_hex32:
	pusha
	movw $0x8, %cx
	movw $hex_string32, %di

.hex_loop_pre:
	pushw %cx
	pushw %di
.hex_loop:
	movl %edx, %eax
	andb $0xF, %al

	movw $hex_to_ascii, %bx

	popw %di
	pushw %di

	xlatb

	movw %cx, %bx
	add $0x1, %di
	movb %al, (%bx,%di)
	rorl $0x4, %edx
	loop .hex_loop

	popw %si
	popw %cx
	add $2, %cx
	movb $0x0E, %ah
.loop:
	lodsb
	int $0x10
	loop .loop
	popa
	ret

hex_string8:  .ascii "0x00"
hex_string16: .ascii "0x0000"
hex_string32: .ascii "0x00000000"
hex_to_ascii: .ascii "0123456789ABCDEF"

/* @func diskld
 * @desc Load disk sectors for initialization.
 * @param sectors [al] : number of sectors to load
 * @param cylinder [ch] : cylinder number
 * @param sector_num [cl] : sector number (1-based)
 * @param head_num [dh] : head number
 * @param drive_num [dl] : drive number (set in BIOS on startup for HDD)
 * @param load_ptr [bx] : location to load sectors at
 * @param load_seg [es] : segment for load_ptr (bx)
 * https://en.wikipedia.org/wiki/INT_13H
 */
diskld:
	pushw %es
	pusha

	pushw %ax
	xorw %ax, %ax
	movw %ax, %ds	/* ds = 0 */
	popw %ax

	movb $0x2, %ah		/* Function number (int 0x13) */

	int $0x13
	jc .err

	popa
	popw %es
	ret
.err:
	movw $disk_err, %si
	call print
	hlt
.stop:	jmp .stop

.data

disk_err: .asciz 		"Error loading disk sectors."
