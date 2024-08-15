SECTIONS {
	.text 0x7c00 : {
		*(.text*);
	}
	.data : {
		*(.data*);
	}
	.rodata : {
		*(.rodata*);
	}
	.bss : {
		*(.bss*);
	}
}
