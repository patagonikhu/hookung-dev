# Programs, flags, etc.
ASM		= nasm
DASM		= ndisasm
CC		= gcc
LD		= ld

# This Program
ORANGESBOOT	= boot/boot.bin boot/loader.bin
ORANGESKERNEL	= kernel.bin
OBJS		= kernel/kernel.o kernel/start.o kernel/i8259.o kernel/global.o kernel/protect.o lib/klib.o lib/kliba.o lib/string.o
DASMOUTPUT	= kernel.bin.asm

BOOT:=start.asm
LDR:=loader.asm
BOOT_BIN:=$(subst .asm,.bin,$(BOOT))
LDR_BIN:=$(subst .asm,.bin,$(LDR))

IMG:=a.img
FLOPPY:=/mnt/floppy/

:install:
dd if=kernel.bin of=a.img bs=512 count=1 conv=notrunc
.PHONY : everything
#dd if=$(BOOT_BIN) of=$(IMG) bs=512 count=1 conv=notrunc
everything :start.o  	
	ld -T link.ld -o kernel.bin start.o main.o gdt.o idt.o irq.o isrs.o kb.o scrn.o time.o
clean :
	rm -f *.o

start.o :start.asm main.o gdt.o idt.o irq.o isrs.o kb.o scrn.o time.o
	nasm -f elf -o start.o start.asm

main.o : main.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o main.o main.c

gdt.o : gdt.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o gdt.o gdt.c

idt.o : idt.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o idt.o idt.c

irq.o : irq.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o irq.o irq.c

isrs.o : isrs.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o isrs.o isrs.c

scrn.o : scrn.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o scrn.o scrn.c

kb.o : kb.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o kb.o kb.c

time.o : time.c
	$(CC) -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o time.o time.c

