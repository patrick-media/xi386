SECTIONS {
	.text 0x50000 : {
		*(xi_kinit);
		*(.text*);
	}
	.data : {
		*(xi_font);
		*(.data*);
	}
	.rodata : {
		*(.rodata*);
	}
	.bss : {
		*(.bss*);
	}
}
