section .data
  str: db "GET /_serverInfo HTTP/1.1", 10, "HOST: localhost", 10, 10
  strlen: equ $-str
  temp_file: db "/sys/class/hwmon/hwmon2/temp1_input"
  temp_file_len: equ $-temp_file
  buff_len: equ 128

section .bss
  socket: resd   1
  socket_addr: resd    2
  buff: resb buff_len
  temp: resb 6
  fd: resd 1

section .text

global _start

_start:
  push ebp
  mov ebp, esp

  mov eax, 5
  mov ebx, temp_file
  mov ecx, 0
  int 0x80
  mov [fd], eax

  mov eax, 3
  mov ebx, [fd]
  mov ecx, temp
  mov edx, 6
  int 0x80

  mov eax, 3
  mov ebx, [fd]
  int 0x80

  push dword 6
  push dword 1
  push dword 2

  mov eax, 102
  mov ebx, 1
  mov ecx, esp
  int 0x80

  add esp, 12

  mov dword[socket], eax

  push dword 0x00000000
  push dword 0x9210
  push word 2
  mov [socket_addr], esp

  mov eax, 102
  mov ebx, 3
  push 16
  push dword[socket_addr]
  push dword[socket]
  mov ecx, esp
  int 0x80

  cmp eax, 0
  jl .fail

.loop:
  mov eax, 3
  mov ebx, dword[socket]
  mov ecx, buff
  mov edx, 128
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov ecx, buff
  mov edx, 128
  int 0x80

  push dword buff_len
  push dword buff
  call bzero
  add esp, 8

  jmp .loop

  mov esp, ebp
  pop ebp

  jmp .exit

.fail:
  mov edx, eax
  mov eax, 1
  mov ebx, edx
  int 0x80

.close_socket:
  mov eax, 3
  mov ebx, dword[socket]
  int 0x80
  jmp .exit

.exit:
  mov eax, 1
  mov ebx, 0
  int 0x80

.print:
  mov eax, 4
  mov ebx, 1
  mov ecx, temp
  mov edx, 6
  int 0x80
  ret

bzero:
  push ebp
  mov ebp, esp
  sub esp, 8

  mov ecx, [ebp + 12]
  mov edx, [ebp + 8]

.loop:
  dec ecx
  cmp ecx, 0
  jl .ret
  mov byte[edx + ecx], 0
  jmp .loop
.ret:
  mov esp, ebp
  pop ebp
  ret
