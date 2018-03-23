all:
	nasm -f elf -g -F stabs main.s -l list.lst
	gcc -m32 -ggdb main.o -nostartfiles -nostdlib -nodefaultlibs -o main
	#ld -melf_i386 -s main.o -o main

test:
	nasm -f elf -g -F stabs test.s
	gcc -m32 -ggdb test.o -nostartfiles -nostdlib -nodefaultlibs -o test

clean:
	rm -rf *.o main