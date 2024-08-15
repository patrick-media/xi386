.code16

.equ mem_map_entries, 0xA500

get_mem_map:
	xorw %ax, %ax
	movw %ax, %es
	movw $0xA504, %di
	xorl %ebx, %ebx
	xorw %bp, %bp
	movl $0x534D4150, %edx
	movl $0xE820, %eax
	movl $0x1, %es:20(%di)
	movl $24, %ecx
	int $0x15
	jc .mem_error

	cmpl $0x534D4150, %eax
	jne .mem_error
	test %ebx, %ebx
	jz .mem_error
	jmp .mem_start

.mem_next:
	movl $0x534D4150, %edx
	movl $24, %ecx
	movl $0xE820, %eax
	int $0x15

.mem_start:
	jcxz .mem_skip
	movl %es:8(%di), %ecx
	orl %es:12(%di), %ecx
	jz .mem_skip

.mem_good:
	incw %bp
	add $24, %di

.mem_skip:
	test %ebx, %ebx
	jz .mem_done
	jmp .mem_next

.mem_error:
	movw $0x0E45, %ax
	int $0x10
.mem_hang: jmp .mem_hang

.mem_done:
	movw %bp, (mem_map_entries)
	ret


print_mem_map:
	pusha
	movl (mem_map_entries), %ecx
	movw $mem_map_entries+4, %bx

	movw $mem_hdr, %si
	call print

.mem_print_loop:
	movl (%bx), %edx
	call print_hex32 // base
	movw $0x0e20, %ax
	int $0x10
	int $0x10
	int $0x10

	movl 8(%bx), %edx
	call print_hex32 // length
	movw $0x0e20, %ax
	int $0x10
	int $0x10
	int $0x10

	movw 16(%bx), %dx
	call print_hex8 // type

	add $24, %bx

	movw $0x0e0a, %ax
	int $0x10
	movb $0x0d, %al
	int $0x10

	loop .mem_print_loop

	popa
	ret


mem_hdr: .asciz		"Base         Length       Type\n"
