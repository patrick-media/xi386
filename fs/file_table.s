/*

Format: "name:type:ss:ls" (newline separates entries)

ss = starting sector (%02x, 2 digit hex)
ls = length in sectors ("             ")

Last byte is 0xFF to denote end of table.

*/

.data

file_table:
	.string "STAGE2:BIN:03:05"
	.byte 0x0a
	.byte 0xff
