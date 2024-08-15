.code16

terminal:
	movb $0x0e, %bh
	call scr_reset

	xorw %dx, %dx
	xorw %bx, %bx
	call scr_set_cursor_pos

	movw $0x0607, %cx
	call scr_set_cursor_style

	movw $terminal_welcome, %si
	call print

terminal_loop_pre:
	movw $terminal_caret, %si
	call print

	xorw %bx, %bx
	movw $terminal_key_buf, %di

terminal_loop:
	movb $0x1, %ah
	int $0x16
	jz .input_skip

	movb $0x0, %ah
	int $0x16

	pushw %ax
//	movw $terminal_key_buf, %di
	stosb
	popw %ax

	movw $terminal_debug, %si
	call print
	movw $terminal_key_buf, %si
	call print
	movw $0x0e0a, %ax
	int $0x10
	movb $0xd, %al
	int $0x10

.input_skip:
	jmp terminal_loop

.terminal_hang: jmp .terminal_hang

terminal_key_buf: .byte 0
. = terminal_key_buf + 64

terminal_welcome: .asciz	"Xi386 Real Mode Terminal\n"
terminal_caret: .asciz		"> "
terminal_debug: .asciz		"terminal_key_buf = "
