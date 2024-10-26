; Filename: PROG3.7.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program converts lowercase letters to uppercase letters.
; Date: October 24, 2024

; TITLE     uppercase conversion of characters TOUPPER.ASM
; Objective: To convert lowercase letters to corresponding uppercase letters.
; Input: Requests a character string from keyboard.
; Output: Prints the input string in uppercase.

.MODEL SMALL
.STACK 100H
.DATA
name_prompt DB 'Please type your name: $'
out_msg     DB 'Your name in capitals is: $'
in_name     DB 31 DUP (?)


.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX


    ; Print the prompt for name input
    MOV DX, OFFSET name_prompt
    MOV AH, 09H
    INT 21H


    ; Read the string
    MOV DX, OFFSET in_name
    MOV AH, 0AH
    INT 21H


    ; New line
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H


    ; Print the output message
    MOV DX, OFFSET out_msg
    MOV AH, 09H
    INT 21H


    ; Convert and display the string in uppercase
    LEA BX, in_name + 1
    MOV CX, [BX - 1]


process_char:
    MOV AL, [BX]
    CMP AL, 0
    JE done


    CMP AL, 'a'
    JL not_lower_case
    CMP AL, 'z'
    JG not_lower_case
    SUB AL, 20H


not_lower_case:
    MOV DL, AL
    MOV AH, 02H
    INT 21H


    INC BX
    LOOP process_char


done:
    ; New line
    MOV AH, 02H
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H


    ; Terminate the program
    MOV AH, 4CH
    INT 21H
main ENDP
END main
