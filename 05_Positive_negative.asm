section .data
    msg1 db "Count of Positive numbers:"
    len1 equ $-msg1

    msg2 db "Count of Negative numbers:"
    len2 equ $-msg2

    array db 10, 12, -21, -12, -19, -34, 41

    nLine db "", 0xA
    lenNLine equ $-nLine

%macro print 2
    mov rax, 01
    mov rdi, 01
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro newLine 0
    mov rax, 01
    mov rdi, 01
    mov rsi, nLine
    mov rdx, lenNLine
    syscall
%endmacro

section .bss
    count resb 2
    positiveCount resb 2
    negativeCount resb 2
    totalCount resb 2

section .text
global _start
_start:
    ; Initialize counters and array pointer
    mov byte[count], 07
    mov byte[positiveCount], 00
    mov byte[negativeCount], 00
    mov rsi, array                  ;given array la point karta 

Up:
    ; Process each element of the array
    mov al, 00
    add al, [rsi]
    js negative                      ;jump if sign=> jar sign negative asel tar jump karel
    inc byte[positiveCount]          ;increments the positive count by 1
    jmp Down
negative:
    inc byte[negativeCount]

Down:
    ; Move to the next element and decrement the counter
    add rsi, 01                      ;pudchya memory location rsi point karel
    dec byte[count]                  ;count decrement hotay 
    jnz Up

    ; Print the results
    mov bl, [positiveCount]
    mov dl, [negativeCount]

b1:
    ; Display count of positive numbers
    print msg1, len1
    mov bh, [positiveCount]
    call displayCount

    newLine

    ; Display count of negative numbers
    print msg2, len2
    mov bh, [negativeCount]
    call displayCount
    newLine

    jmp Exit

displayCount:
    ; Convert the count to ASCII and print it
    mov byte[count], 02
loop:
    rol bh, 04
    mov al, bh
    AND al, 0FH
    cmp al, 09
    jbe l1
    add al, 07h
l1:
    add al, 30h
    mov [totalCount], al
    print totalCount, 02
    dec byte[count]
    jnz loop
    ret

Exit:
    ; Exit the program
    mov rax, 60
    mov rdi, 00
    syscall


;Algorithm
;1. Start.
;2. Initialize an array of 10 numbers or accept 10 numbers from user and store them in one array.
;3. Initialize pos_counter=0, neg_counter=0, index_reg=array address, counter=10
;4. Read the number from index_reg into a register.
;5. Perform addition with 00H and check sign bit
;6. If sign bit==1 then
;increment neg_counter=neg_counter+1
;else
;increment pos_counter=pos_counter+1
;end if
;7. Increment index_reg= index_reg+1
;8. Decrement counter=counter-1
;9. If counter!=0 then goto step number 4 else
;continue
;10. Print message “Positive numbers are:” and print pos_counter.
;11. Print message “Negative numbers are:” and print neg_counter.
;12. Exit.
