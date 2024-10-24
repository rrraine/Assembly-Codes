; Filename: PROG3.5.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the hex equivalent of the ASCII code of a character.
; Date: October 24, 2024

; TITLE     Hex equivalent of characters  HEXCHAR.ASM
; Objective: To print the hex equivalent of ASCII character code.
; Input: Requests a character from keyboard.
; Output: Prints the ASCII code of the input character in hex.

.MODEL SMALL
.STACK 100H
.DATA
char_prompt DB 'Please input a character: ',0
out_msg1    DB 'The ASCII code of ',0
out_msg2    DB ' in hex is ',0
query_msg   DB 'Do you want to quit (Y/N)? ',0
.CODE
INCLUDE io.mac 
main PROC
    STARTUP

read_char:
    PutStr char_prompt ; request a char. input
    GetCh AL           ; read input character
    mov AH,AL
    PutStr out_msg1
    PutCh AL
    PutStr out_msg2
    mov AH,AL           ; save input character in AH
    shr AL,4            ; move upper 4 bits to lower half
    mov CL,2            ; loop count = 2 hex digits to print

print_digit:
    cmp AL,9            ; if greater than 9
    ja  A_to_F          ; convert to A through F digits
    add AL,'0'          ; otherwise, convert to 0 through 9
    jmp skip
A_to_F:
    add AL,'A'-10       ; subtract 10 and add 'A'
skip:
    PutCh AL            ; write the first hex digit
    mov AL,AH           ; restore input character in AL
    and AL,0FH          ; mask off the upper half byte
    loop print_digit    ; repeat for second digit

    mov AH,0
    PutStr query_msg    ; query user whether to terminate
    GetCh AL            ; read response
    cmp AL,'Y'          ; if response is not 'Y'
    jne read_char       ; otherwise, terminate program

done:
    .EXIT
main ENDP
END main
