CCFLAGS = -m32 -Wall -Wextra -Wpedantic -ffreestanding \
	  -fno-pie -fno-stack-protector -I ./include/
BOOTOBJ = bin/boot.o bin/file_table.o
S2OBJ = bin/stage2.o
PKOBJ = bin/kinit.o bin/font.o

all: clean xboot xs2 xpk
	@i386-elf-ld -o xi386.elf bin/xboot.elf bin/xs2.elf bin/xpk.elf --oformat elf32-i386
	@i386-elf-objcopy -O binary xi386.elf xi386.bin
	@echo Creating image...done

xboot: $(BOOTOBJ)
	@i386-elf-ld -o bin/xboot.elf $^ -T build/xboot.ld --oformat elf32-i386

xs2: $(S2OBJ)
	@i386-elf-ld -o bin/xs2.elf $^ -T build/xs2.ld --oformat elf32-i386

xpk: $(PKOBJ)
	@i386-elf-ld -o bin/xpk.elf $^ -T build/xpk.ld --oformat elf32-i386

bin/%.o: */%.s
	@i386-elf-as -o $@ -c $^
	@echo Compiling $^...done

bin/%.o: */%.c
	@i386-elf-gcc -Iinclude -o $@ -c $^ $(CCFLAGS)
	@echo Compiling $^...done

bin/%.o: kernel/*/%.c
	@i386-elf-gcc -Iinclude -o $@ -c $^ $(CCFLAGS)
	@echo Compiling $^...done

qemu: all
	@qemu-system-i386 \
	-monitor stdio \
	-m 128M \
	-drive format=raw,file=xi386.bin,if=ide,index=0,media=disk \
	-rtc base=localtime,clock=host,driftfix=slew \
	-vga std

clean:
	@rm -f $(BOOTOBJ) $(S2OBJ) $(PKOBJ)
