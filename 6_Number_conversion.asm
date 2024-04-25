
;Write 64 bit ALP to convert 4-digit Hex number into its equivalent
;BCD number and 5-digit BCD number into its equivalent HEX
;number. Make your program user friendly to accept the choice from
;user for:
;a) HEX to BCD b) BCD to HEX c) EXIT

section .data
    menuMsg: db "1. HEX to BCD", 0x0A
             db "2. BCD to HEX", 0x0A
             db "3. Exit", 0x0A
    menuLen equ $ - menuMsg                         ;calculates the length of the menuMsg string.

    choicePrompt: db "Enter your Choice: "           ;initialized choicePrompt message
    choicePromptLen equ $ - choicePrompt

    hexPrompt: db "Enter HEX number: "                ;initialized hexPrompt message
    hexPromptLen equ $ - hexPrompt

    bcdPrompt: db "Enter BCD number: "                ;initialized badPrompt message
    bcdPromptLen equ $ - bcdPrompt

    bcdResultMsg: db "Equivalent BCD number is: "        ;initialized bcdResult message
    bcdResultLen equ $ - bcdResultMsg

    hexResultMsg: db "Equivalent HEX number is: "
    hexResultLen equ $ - hexResultMsg

    newLine: db " ", 0x0A ;used for newline
    newLineLen equ $ - newLine

section .bss                                            ;bss section allocates memory for variables that the program will use during its execution. These variables are uninitialized at the start of the program and may be filled with values as the program runs
    number: resb 6                                       ;resb: reserves byte 
    result: resb 4
    answer: resb 4
    digitCount: resb 01
    userChoice: resb 02

section .text
global _start
_start:

menu:
    ; Display menu options            
    mov rax, 1                            ; read instruction
    mov rdi, 1                            ; stdin file descriptor
    mov rsi, newLine                      ; memory location where the input is to be stored
    mov rdx, newLineLen                   ; number of bytes to be read (16 bytes for 64 bit hexadecimal number and 1 byte for newline character)
    syscall                               ; system call to read the input

    mov rax, 1
    mov rdi, 1
    mov rsi, newLine  
    mov rdx, newLineLen
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, menuMsg        
    mov rdx, menuLen
    syscall                            ;system call is made to print the menu msg(different options)

    mov rax, 1
    mov rdi, 1
    mov rsi, choicePrompt
    mov rdx, choicePromptLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, userChoice
    mov rdx, 02
    syscall

    cmp byte[userChoice], 31H    //userChoice madhli value la 31H(ASCI eqivalent 1) sobat compare karta
    je case1

    cmp byte[userChoice], 32H
    je case2

    cmp byte[userChoice], 33H
    je case3

case2:
    ; BCD to HEX conversion
    mov rax, 1
    mov rdi, 1
    mov rsi, bcdPrompt
    mov rdx, bcdPromptLen
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, number
    mov rdx, 6
    syscall

    xor rax, rax
    mov rbx, 10
    mov rcx, 5

bcdToHexLoop:
    xor rdx, rdx        ; Clear rdx register (used for intermediate calculations)
    mul ebx             ; Multiply rax by ebx (eax = eax * ebx), result stored in rdx:eax

    xor rdx, rdx        ; Clear rdx register again
    mov dl, [rsi]       ; Load the byte at the memory address pointed to by rsi into dl
    sub dl, 30H         ; Subtract 30H (48 in decimal) from dl to convert ASCII digit to numeric value

    add rax, rdx       ; Add the numeric value in dl to rax (accumulator)

    inc rsi             ; Increment rsi to point to the next byte in the input string
    dec rcx             ; Decrement rcx (loop counter) to keep track of remaining iterations
    jnz bcdToHexLoop    ; Jump to bcdToHexLoop if rcx is not zero (loop until rcx becomes zero)

    mov [result], ax    ; Store the final result in the variable 'result' (assuming it's a memory location)

    ; Output the result as a hexadecimal number
    mov rax, 1          ; System call number 1 (write)
    mov rdi, 1          ; File descriptor 1 (stdout)
    mov rsi, hexResultMsg ; Address of the message to be printed
    mov rdx, hexResultLen ; Length of the message
    syscall             ; Perform the system call to print the message

    mov ax, [result]    ; Load the result back into ax (assuming it's a 16-bit value)
    call displayNumber  ; Call a subroutine to display the number

    jmp menu            ; Jump to the 'menu' label (assuming it exists)


case1:
    ; HEX to BCD conversion
    mov rax,


;Test Case 1:
;BCD - 4391
;HEX - ABCD
