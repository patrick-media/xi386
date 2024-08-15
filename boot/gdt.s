.code16

.align 16
gdt_start:
	.quad 0x0
gdt_code:
	.word 0xffff
	.word 0x0000
	.byte 0x00
	.byte 0b10011010
	.byte 0b11001111
	.byte 0x00
gdt_data:
	.word 0xffff
	.word 0x0000
	.byte 0x00
	.byte 0b10010010
	.byte 0b11001111
	.byte 0x00
gdt_end:

.align 16
gdtp:
	.word gdt_end - gdt_start	/* Size (0-15) */
	.long gdt_start			/* Start ptr (16-47) */
