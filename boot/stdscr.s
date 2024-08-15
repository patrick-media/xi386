.code16

.extern scr_reset
.extern scr_set_cursor_pos
.extern scr_get_cursor_attr
.extern scr_set_cursor_style

/* @func scr_reset
 * @desc Reset (clear) the screen with the desired color.
 * @param color [bh] : clear color
 * https://en.wikipedia.org/wiki/INT_10H
 */
scr_reset:
	pusha
	movw $0x0600, %ax	/* Function set (scroll up, int 0x10) */
	xorw %cx, %cx		/* Top left (0, 0) */
	movw $0x184F, %dx	/* Bottom right (79, 24) */
	int $0x10

	/* Reset the cursor position */
	xorw %bx, %bx	/* Page 0 */
	xorw %dx, %dx	/* Row & column (0, 0) */
	call scr_set_cursor_pos
	
	popa
	ret

/* @func scr_set_cursor_pos
 * @desc Set the cursor position
 * @param page [bh] : page number
 * @param row [dh] : y position of cursor
 * @param col [dl] : x position of cursor
 */
scr_set_cursor_pos:
	pushw %ax
	movw $0x0200, %ax	/* Function set (cursor position, ah=02, int 0x10) */
	int $0x10
	popw %ax
	ret

/* @func scr_get_cursor_attr
 * @desc Get the cursor position returned in DX (dl, dh) -> (col, row); also returns style.
 * @param page [bh] : page number
 * @ret pos [dx] : position returned
 * @ret style [cx] : cursor style (ch, cl) -> (start, end)
 */
scr_get_cursor_attr:
	pushw %ax
	movb $0x3, %ah		/* Function set (get cursor position, ah=0x3, int 0x10) */
	int $0x10
	popw %ax
	ret

/* @func scr_set_cursor_style
 * @desc Customize the cursor style (block, line, etc.)
 * @param row_start [ch] : row to start drawing the cursor (top, min=0)
 * @param row_end [cl] : row to stop drawing the cursor (bottom, max=7)
 * https://en.wikipedia.org/wiki/INT_10H
 */
scr_set_cursor_style:
	pushw %ax
	movw $0x0100, %ax	/* Function set (cursor shape, ah=01, int 0x10) */
	int $0x10
	popw %ax
	ret

/* @func scr_set_res
 * @desc Set the resolution of the screen
 * @param res_index [al] : resolution index for INT 0x10
 * https://en.wikipedia.org/wiki/INT_10H
 */
scr_set_res:
	movb $0x0, %al
	int $0x10
	call scr_reset
	ret
