SECTIONS {
	.text 0x7c00 : {
		*(.text*);
		/*
		. = 0x8400;
		*(xi_kinit);
		. = 0x9400;
		*(xifont);
		*/
	}
	xi_kinit 0x10000 : {
		*(xi_kinit);
		/*
		*(.data*);
		*(.rodata*);
		*(.bss*);
		*/
	}
	xi_font 0x11000 : {
		*(xi_font);
	}
	.data : {
		*(.data*);
		*(xi_kinit);
	}
	.rodata : {
		*(.rodata*);
		*(xi_kinit);
	}
	.bss : {
		*(.bss*);
		*(xi_kinit);
	}
}
