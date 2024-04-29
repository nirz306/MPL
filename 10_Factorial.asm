; Write x86 ALP to find the factorial of a given integer number on a command line
;by using recursion.
; Explicit stack manipulation is expected in the code.
;------------------------------ .data section—---------------------------------------
section .data
  msgno: db 'Number is:',0xa
  msnoSize: equ $-msgno
  msgfact: db 'Factorial is:',0xa
  msgfactSize: equ $-msgFact
  newLine: db 10
;------------------------------ .bss section--------------------------------------
section .bss
  fact: resb 8
  num: resb 2
;------------------------------ define macro for print and stop------------------------------
%macro Print 2
  mov rax,01
  mov rdi,01
  mov rsi,%1
  mov rdx,%2
  syscall
  %endmacro

%macro Stop
  mov rax,60
  mov rdi,0
  syscall
  %endmacro

;------------------------------ .text section—---------------------------------------
section .txt
global _start
_start:
  pop rbx                               ; Remove number of arguments from stack
  pop rbx                               ; Remove the program name from stack
  pop rbx                               ; Remove the actual number whose factorial is
  ; to be calculated (Address of number) from stack

  mov [num],rbx
  Print msgno,msgnoSize                         ;msg :- Number is
  Print [num],4                                 ;print number accepted from command line

  mov rsi,[num]                                  ;point rsi to num
  mov rcx,02                                     ;load number of digits to display
  xor rbx,rbx
  call aToH
  
  mov rax,rbx                                     ;store number in rax
  
  call factP
  
  mov rcx,08
  mov rdi,fact
  xor bx,bx
  mov ebx,eax
  call hToA
  
  Print newLine
  Print msgfact, msgfactSize
  
  Print fact,8
  Print newLine
  Stop                                           ;exit program
;************ recursive Factorial Procedure *****************
  factP:
    dec rbx                                      ;decrement rbx by 1
    cmp rbx,01
    je b1                                        ;jump if rbx == 1 to b1
    cmp rbx,00
    je b1                                        ;jump if rbx == 0 to b1
    mul rbx
    call factP
  b1:
    ret

;********************* Ascii Hex - Hex **************
  aToH:
    up1: rol bx,04                                 ;rotate number left by four bits
    mov al,[rsi]
    cmp al,39H
    jbe A2
    sub al,07H
  A2: 
    sub al,30H
    add bl,al
    inc rsi
    loop up1
    ret

;********************* Hex- Ascii Hex **************
  hToA:
    next1: 
      rol ebx,4
      mov ax,bx
      and ax,0fH
  
      cmp ax,09H
      jbe p1
      add ax,07H
    p1: 
      add ax,30H
      mov [rdi],ax
      inc rdi
      loop next1
      ret

;*******output*******
;nasm -f elf64 ass9_rec.asm
; ld -o a ass9_rec.o
;./a 04
;04
;00000024
