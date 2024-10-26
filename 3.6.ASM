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
char_prompt DB 'Please input a character: $'
out_msg1    DB 0AH, 0DH, 'The ASCII code of ',0
out_msg2    DB ' in hex is $'
query_msg   DB 'Do you want to quit (Y/N)? $'
hex_table   DB '0123456789ABCDEF'


.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX


read_char:
    ; Print the prompt for character input
    MOV DX, OFFSET char_prompt
    MOV AH, 09H
    INT 21H


    ; Read the character
    MOV AH, 01H
    INT 21H
    MOV BL, AL


    ; Print the first message
    MOV DX, OFFSET out_msg1
    MOV AH, 09H
    INT 21H


    ; Print the character
    MOV DL, BL
    MOV AH, 02H
    INT 21H


    ; Print the second message
    MOV DX, OFFSET out_msg2
    MOV AH, 09H
    INT 21H


    ; Use xlat to convert and print the hex code
    MOV BX, OFFSET hex_table
    MOV AL, BL
    SHR AL, 4
    XLAT
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    MOV AL, BL
    AND AL, 0FH
    XLAT
    MOV DL, AL
    MOV AH, 02H
    INT 21H


    ; New line
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H


    ; Ask if the user wants to quit
    MOV DX, OFFSET query_msg
    MOV AH, 09H
    INT 21H


    ; Read the response
    MOV AH, 01H
    INT 21H
    MOV DL, AL
    MOV AH, 02H
    INT 21H


    CMP AL, 'Y'
    JNE read_char


done:
    ; Terminate the program
    MOV AH, 4CH
    INT 21H
main ENDP
END main
