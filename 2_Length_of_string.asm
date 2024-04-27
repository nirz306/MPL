section .data
section .bss
  str1 resb 200
  result resb 200
section .text
global _start
_start:
  mov rax, 0
  mov rdi, 0
  mov rsi, str1
  mov rdx, 200
  syscall

  mov rbx,rax                                                     ;store number in rbx ----------------------
  mov rdi, result                                                 ;point rdi to result variable
  mov cx,16                                                       ;load count of rotation in cl
  up1:
    rol rbx,04                                                    ;rotate number left by four bits
    mov al,bl                                                     ;move lower byte in al
    and al,0fh                                                    ;get only LSB
    cmp al,09h                                                    ;compare with 39h
    jg add_37                                                     ;if greater than 39h skip add 37(jump if greater)
    add al,30h
    jmp skip                                                      ;else add 30
  add_37 :
    add al,37h
  skip: 
    mov [rdi],al                                                   ;store ascii code in result variable
    inc rdi                                                        ;point to next byte
    dec cx                                                         ;decrement the count of digits to display
    jnz up1                                                        ;if not zero jump to repeat
  
  ;write result
  mov rax,1
  mov rdi,1
  mov rsi,result
  mov rdx,16
  syscall

;exit
mov rax,60
mov rdi,0
syscall
