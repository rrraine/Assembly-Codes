; Filename: PROG3.6.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the hex equivalent of the ASCII code of a character.
; Date: October 24, 2024

; TITLE: Hex equivalent of characters  HEXCHAR.ASM
; Objective: To print the hex equivalent of
; ASCII character code. Demonstrates the use of xlat instruction.

.MODEL SMALL
.STACK 100H
.DATA
char_prompt DB 'Please input a character: ',0
out_msg1    DB 'The ASCII code of ''',0
out_msg2    DB ''' in hex is ',0
query_msg   DB 'Do you want to quit (Y/N)? ',0
hex_table   DB '0123456789ABCDEF'

.CODE
.486
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
    mov BX,OFFSET hex_table ; BX = translation table
    shr AL,4                 ; move upper 4 bits to lower half
    xlatb                    ; replace AL with hex digit
    PutCh AL                 ; write the first hex digit
    mov AL,AH                ; restore input character to AL
    and AL,0FH               ; mask off upper 4 bits
    xlatb                    ; replace AL with hex digit
    PutCh AL                 ; write the second hex digit

    mov AH,0
    PutStr query_msg         ; query user whether to terminate
    GetCh AL                 ; read response
    cmp AL,'Y'               ; if response is not 'Y'
    jne read_char            ; otherwise, terminate program

done:
    .EXIT
main ENDP
END main

