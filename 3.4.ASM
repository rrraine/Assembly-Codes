; Filename: PROG3.4.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the binary equivalent of the ASCII code of a character.
; Date: October 24, 2024

;Program 3.4
;TITLE  Binary equivalent of characters   BINCHAR.ASM
;Objective: To print the binary equivalent of ASCII character code.
;Input: Requests a character from keyboard.
;Output: Prints the ASCII code of the input character in binary.

..MODEL SMALL
.STACK 100H


.DATA
    char_prompt DB 0DH, 0AH, 'Please input a character: $'
    out_msg1    DB 'The ASCII code of "',0
    out_msg2    DB ', in binary is $'
    query_msg   DB 0DH, 0AH, 'Do you want to quit (Y/N)? $'
    newline     DB 0DH, 0AH, '$'


.CODE
    MAIN PROC
        ; Set up the data segment
        MOV AX, @DATA
        MOV DS, AX


    MAIN_LOOP:
        ; Print char_prompt (Please input a character)
        MOV AH, 09H
        LEA DX, char_prompt
        INT 21H


        ; Get the character input
        MOV AH, 01H
        INT 21H
        MOV BL, AL  ; Store the character in BL for processing


        ; Print a newline
        MOV AH, 09H
        LEA DX, newline
        INT 21H


        ; Print out_msg1 ("The ASCII code of '")
        MOV AH, 09H
        LEA DX, out_msg1
        INT 21H


        ; Print the character entered
        MOV DL, BL
        MOV AH, 02H
        INT 21H


        ; Print out_msg2 ('", in binary is')
        MOV AH, 09H
        LEA DX, out_msg2
        INT 21H


        ; Convert and print the binary equivalent
        MOV CL, 8   ; Set counter for 8 bits
    PRINT_BINARY:
        MOV AH, 02H ; DOS function to print a single character
        ROL BL, 1   ; Rotate left to get the MSB in carry
        JC  PRINT_ONE
        MOV DL, '0' ; Print '0' if no carry
        JMP PRINT_CHAR
    PRINT_ONE:
        MOV DL, '1' ; Print '1' if carry set
    PRINT_CHAR:
        INT 21H
        DEC CL      ; Decrement bit counter
        JNZ PRINT_BINARY ; Loop until all bits are printed


        ; Print a newline
        MOV AH, 09H
        LEA DX, newline
        INT 21H


        ; Ask the user if they want to quit (Y/N)
        MOV AH, 09H
        LEA DX, query_msg
        INT 21H


        ; Get the user's response
        MOV AH, 01H
        INT 21H


        ; Check if the user entered 'Y' or 'y'
        CMP AL, 'Y'
        JE QUIT_PROGRAM
        CMP AL, 'y'
        JE QUIT_PROGRAM


        ; Otherwise, continue the loop
        JMP MAIN_LOOP


    QUIT_PROGRAM:
        ; Exit program
        MOV AH, 4CH
        INT 21H


    MAIN ENDP
END MAIN
