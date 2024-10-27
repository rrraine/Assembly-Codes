; Filename: PROG3.5.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the hex equivalent of the ASCII code of a character.
; Date: October 24, 2024


.MODEL SMALL
.STACK 100H

.DATA
    char_prompt DB 0DH, 0AH, 'Please input a character: $'  ; Prompt to enter a character
    out_msg1    DB 'The ASCII code of "', 0  ; Message for the first part of the output
    out_msg2    DB '", in hexadecimal is: $' ; Corrected: Added $ to terminate the string
    query_msg   DB 0DH, 0AH, 'Do you want to quit (Y/N)? $'
    newline     DB 0DH, 0AH, '$'             ; New line

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

        ; Print out_msg2 ('", in hexadecimal is:')
        MOV AH, 09H
        LEA DX, out_msg2
        INT 21H

        ; Convert and print the hexadecimal equivalent of the character
        MOV AL, BL  ; Load the character into AL
        CALL PRINT_HEX ; Call the procedure to print the hex equivalent

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

; Procedure to print a hexadecimal number
PRINT_HEX PROC
    ; Convert and print the higher nibble (first hex digit)
    MOV AL, BL         ; Load the character into AL
    SHR AL, 4          ; Shift right to get the high nibble in AL
    CALL PRINT_HEX_DIGIT ; Print the high nibble

    ; Convert and print the lower nibble (second hex digit)
    MOV AL, BL         ; Reload the original character into AL
    AND AL, 0FH        ; Mask the higher nibble, leaving the lower nibble
    CALL PRINT_HEX_DIGIT ; Print the low nibble

    RET
PRINT_HEX ENDP

; Procedure to print a single hex digit (0-9, A-F)
PRINT_HEX_DIGIT PROC
    CMP AL, 9          ; Compare with 9
    JLE PRINT_DIGIT    ; If less than or equal to 9, print as a number

    ; If the digit is A-F (10-15), adjust to print letters
    ADD AL, 7          ; Adjust to match ASCII code for 'A' to 'F'

PRINT_DIGIT:
    ADD AL, '0'        ; Convert the digit to ASCII
    MOV DL, AL         ; Move it into DL for printing
    MOV AH, 02H        ; DOS function to print a single character
    INT 21H
    RET
PRINT_HEX_DIGIT ENDP

END MAIN
