; Filename: PROG3.7.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program converts lowercase letters to uppercase letters.
; Date: October 24, 2024

.MODEL SMALL
.STACK 100H
.DATA
name_prompt DB 'Please type your name: $'
out_msg     DB 'Your name in capitals is: $'
in_name     DB 31        ; Maximum length for input
            DB ?         ; Length of the actual input
            DB 30 DUP (?) ; Space for 30 characters max

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
    LEA BX, in_name + 2    ; Start at first character of input
    MOV CL, in_name[1]     ; Length of input

process_char:
    MOV AL, [BX]           ; Load the character
    CMP AL, 'a'            ; Check if it's a lowercase letter
    JL not_lower_case
    CMP AL, 'z'
    JG not_lower_case
    SUB AL, 20H            ; Convert to uppercase

not_lower_case:
    MOV DL, AL
    MOV AH, 02H
    INT 21H

    INC BX                 ; Move to the next character
    DEC CL                 ; Decrement count
    JNZ process_char       ; Repeat until count reaches zero

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
