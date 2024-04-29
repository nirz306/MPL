%macro rw 3
    mov rax, %1
    mov rdi, 01
    mov rsi, %2
    mov rdx, %3
syscall
%endmacro rw
section .data
    count db 05h
    msg1 db "Enter number: "
    msg2 db "The number is: "
section .bss
    numarr resb 17
    global _start
section .text
_start:
loop :
    rw 01,msg1,14
    rw 00,numarr,17
    rw 01,msg2,15
    rw 01,numarr,17
    dec byte[count]
    xy: jnz loop
    mov rax, 60
    mov rdi, 00
    syscall
;OUTPUT:
;[pict@localhost ~]$ cd Documents/
;[pict@localhost Documents]$ nasm -f elf64 assn1.asm
;[pict@localhost Documents]$ ld -o temp assn1.o
;[pict@localhost Documents]$ ./temp
;Enter number: 6541239871598742
;The number is: 6541239871598742
;Enter number: 1234567891234567
;The number is: 1234567891234567
;Enter number: 9518476239518475
;The number is: 9518476239518475
;Enter number: 9876543219876543
;The number is: 9876543219876543
;Enter number: 7625891348759126
;The number is: 7625891348759126
;[pict@localhost Documents]$ ^
