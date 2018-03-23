all:
	nasm -f elf -g -F stabs main.s -l list.lst
	gcc -m32 -ggdb main.o -nostartfiles -nostdlib -nodefaultlibs -o main
	#ld -melf_i386 -s main.o -o main

clean:
	rm -rf *.o main