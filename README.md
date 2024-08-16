# Xi386
Xi386 is an operating system designed for the Intel 80386 (i386) utilizing MBR disk partitioning and no secure boot/UEFI utilities (currently).
## Current Features:
* In-progress file table & basic filesystem
* Super awesome ASCII splash screen
* Startup utilities: safe mode (WIP), real mode terminal (WIP), and resolution changing (WIP)
* Full memory map ready for memory virtualization! (VMM coming soon)
* Support for VESA BIOS Extensions version 3.0, allowing for a resolution of 1920x1080 @ 32bpp
* 32-bit protected mode fully equipped with C

# Build
### GCC Cross Compiler
For more information, follow the [OSDEV Wiki Tutorial](wiki.osdev.org/GCC_Cross-Compiler).
Required packages (Debian/Ubuntu copy/paste):
```
sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo
```
1. Download GNU GCC & Binutils source code.
```
# Use the most recent version of Binutils. As of writing, mine is 2.43.
curl -# -O https://ftp.gnu.org/gnu/binutils/binutils-X.XX.tar.gz
# Unzip
tar xf binutils-X.XX.tar.gz

# Use the most recent version of GCC. As of writing, it is 14.2.0.
curl -# -O https://ftp.gnu.org/gnu/gcc/gcc-XX.X.X.tar.gz
# Unzip
tar xf gcc-XX.X.X.tar.gz
```
2. Set up environment variables.
```
# Any path will work, this was what was on the Wiki.
export PREFIX="$HOME/opt/cross
# My target is i386 despite the Wiki's suggested i686.
export TARGET=i386-elf
# Always add the custom GCC's bin folder to your PATH.
export PATH="$PREFIX/bin:$PATH"
```
3. Build the respective pieces of software.
### Binutils
```
# Name this folder whatever you want and place it wherever you want.
mkdir build-binutils
cd build-binutils
# Reference your unzipped Binutils source folder configure file.
../binutils-X.XX/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
# I recommend using -j to make this faster - I always forget.
make
make install
```
### GCC
```
# Name this folder whatever you want and place it wherever you want.
mkdir build-gcc
cd build-gcc
# Reference your unzipped GCC source folder configure file.
../gcc-XX.X.X/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
# I recommend using -j to make this faster - I always forget.
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```
4. Profit\
\
The compiler and GNU Binutils should be installed. Check this by running `i386-elf-gcc --version` and `i386-elf-ld --version`. Remember to always add to your PATH (or automate): `export PATH="$HOME/opt/cross/bin:$PATH"` (this is the same as the previous `$PREFIX/bin` that we added earlier, just verbose this time).

# Run
The following are the rules specified in the Makefile:
```
# Assembles and links the bootloader into an intermediate ELF file.
make xboot
# Assembles and links the second stage bootloader into an intermediate ELF file.
make xs2
# Assembles/compiles and links the pre-kernel entry into an intermediate ELF file.
make xpk
# Deletes the bin folder, removing all object files.
make clean
# Executes 'all' (below), and initiates an instance of qemu-system-i386 with 128 MB of RAM.
make qemu
# Executes 'xboot', 'xs2', and 'xpk', compiling/assembling/linking all files into the final ELF and BIN file.
make all
```
\
In order to run the system and test that the environment is set up properly, simply type `make qemu`. An ASCII Xi386 logo should appear for several seconds, followed by a blue screen (and possibly text - features are up in the air for now).
