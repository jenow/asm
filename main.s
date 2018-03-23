section .data
  str: db "debug", 10
  strlen: equ $-str

section .bss
  socket: resd   1
  socket_addr: resd    2

section .text

global _start

.print:
  mov eax, 4
  mov ebx, 1
  mov ecx, str
  mov edx, strlen
  int 0x80

_start:
  push ebp
  mov ebp, esp

  push dword 6
  push dword 1
  push dword 2

  mov eax, 102
  mov ebx, 1
  mov ecx, esp
  int 0x80

  mov dword[socket], eax

  push dword 0x7F000001
  push dword 7512
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

  mov eax, 4
  mov ebx, dword[socket]
  mov ecx, str
  mov edx, strlen
  int 0x80

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