/* <sector 1> */
.code16

.global _start

/* @func _start
 * @desc Entry point of the OS.
 */
_start:
	movw $0x3000, %sp
	movw %sp, %bp
	pushw $0
	popw %es

	movw $beginning_str, %si
	call bs_print

	xorw %ax, %ax
	movb $0x3, %al
	int $0x10	/* Change graphics mode */

	// TODO ATA PIO
	// TODO need to load more in stage 2; relocate stage 2 to 0x1000; load kernel init to higher memory (0x50000?)
bs_diskld:
	movb $0x5, %al	/* Sector count to read */

	movb $0x0, %ch /* Clyinder number */
	movb $0x2, %cl /* Sector number (1-based) */
	movb $0x0, %dh /* Head number */

	pushw $0x0
	popw %es
	movw $0x1000, %bx /* Load at 0000:1000 */

	int $0x13	/* Load sectors */

	jc bs_diskld

	jmp $0x0000, $0x1000 /* jmp stage2 */

__die:
	movw $hang, %si
	call bs_print
.__die:
	jmp .__die


bs_print:
	pusha
	movb $0x0e, %ah
bs_print_inner:
	lodsb

	cmpb $0, %al
	je bs_print_ret
	cmpb $0x0a, %al
	je bs_print_nl

	int $0x10
	jmp bs_print_inner
bs_print_ret:
	popa
	ret
bs_print_nl:
	movb $0x0a, %al
	int $0x10
	movb $0x0d, %al
	int $0x10
	jmp bs_print_inner


.data
/*
 * Data Section
 */

/* Initialization Strings */
beginning_str: .asciz 		"xi init..."
hang: .asciz			"We are hanging here..."

.text

/* Boot Signature */
. = _start + 510
.word 0xaa55
/* </sector 1> */
