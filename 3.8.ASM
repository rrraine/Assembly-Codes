; Filename: PROG3.8.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the sum of individual digits of a number.
; Date: October 24, 2024

; TITLE Add individual digits of a number ADDIGITS.ASM
; Objective: To find the sum of individual digits of a given number.
;            Shows character to binary conversion of digits.
; Input: Requests a number from keyboard.
; Output: Prints the sum of the individual digits.

.MODEL SMALL
.STACK 100H

.DATA
    number_prompt DB 'Please type a number (up to 11 digits): ', 0
    out_msg DB 'The sum of individual digits is: ', 0
    number DB 11 DUP ('0')

.CODE
INCLUDE io.mac 

main PROC
    .STARTUP

    ; Prompt the user for input
    PutStr number_prompt
    GetStr number, 11
    nwln

    ; Initialize sum to 0
    mov BX, OFFSET number   ; BX := address of the input string
    xor DX, DX              ; DX := 0 (DX will hold the sum)

repeat_add:
    mov AL, [BX]            ; Load the current character into AL
    cmp AL, 0               ; Check if it is the NULL terminator (end of string)
    je done                 ; If yes, exit the loop

    and AL, 0FH             ; Convert ASCII character to binary (extract lower 4 bits)
    add DL, AL              ; Add the binary value to sum (DL)

    inc BX                  ; Move to the next character
    jmp repeat_add          ; Repeat the process

done:
    ; Display the sum of the digits
    PutStr out_msg
    PutInt DX
    nwln

    .EXIT
main ENDP

END main

