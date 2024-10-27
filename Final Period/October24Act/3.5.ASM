; Filename: PROG3.5.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the hex equivalent of the ASCII code of a character.
; Date: October 24, 2024


.MODEL SMALL
.STACK 100H
.DATA
    char_prompt DB 0AH,'Please input a character: $'
    out_msg1 DB 'The ASCII code of ''$'
    out_msg2 DB "', in hexadecimal is $"
    query_msg DB 'Do you want to quit (Y/N): $'
    char_input DB ?  ; Variable to store character input
    newline     DB 0DH, 0AH, '$'             ; New line
   
.CODE
main PROC
    .STARTUP


MAIN_LOOP:
read_char:
    ; Display char_prompt message
    MOV DX, OFFSET char_prompt
    MOV AH, 09h           ; DOS function to display a string
    INT 21h


    ; Get character input (without echo) and store in char_input
    MOV AH, 01h           ; DOS function to read character
    INT 21h
    MOV char_input, AL    ; Store character in char_input


    ; New line
    MOV AH, 02h
    MOV DL, 0Dh           ; Carriage return
    INT 21h
    MOV DL, 0Ah           ; Line feed
    INT 21h


    ; Display out_msg1 message
    MOV DX, OFFSET out_msg1
    MOV AH, 09h
    INT 21h


    ; Display the character stored in char_input
    MOV DL, char_input    ; Move input character to DL for display
    MOV AH, 02h
    INT 21h


    ; Display out_msg2 message
    MOV DX, OFFSET out_msg2
    MOV AH, 09h
    INT 21h


    ; Load the character input for hexadecimal conversion
    MOV AL, char_input    ; Move the character into AL
    CALL PRINT_HEX        ; Call the procedure to print the hex equivalent


    ; Print a newline
    MOV AH, 09H
    LEA DX, newline
    INT 21H


    ; Display query_msg message
    MOV DX, OFFSET query_msg
    MOV AH, 09h
    INT 21h


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
    MOV AH, AL          ; Copy the ASCII code into AH
    SHR AL, 4           ; Shift right to get the high nibble in AL
    CALL PRINT_HEX_DIGIT ; Print the high nibble


    ; Convert and print the lower nibble (second hex digit)
    MOV AL, char_input  ; Load the original character back into AL
    AND AL, 0FH         ; Mask to get the lower nibble
    CALL PRINT_HEX_DIGIT ; Print the low nibble


    RET
PRINT_HEX ENDP


; Procedure to print a single hex digit (0-9, A-F)
PRINT_HEX_DIGIT PROC
    CMP AL, 9           ; Compare with 9
    JLE PRINT_DIGIT     ; If less than or equal to 9, print as a number


    ; If the digit is A-F (10-15), adjust to print letters
    ADD AL, 7           ; Adjust to match ASCII code for 'A' to 'F'


PRINT_DIGIT:
    ADD AL, '0'         ; Convert the digit to ASCII
    MOV DL, AL          ; Move it into DL for printing
    MOV AH, 02H         ; DOS function to print a single character
    INT 21H
    RET
PRINT_HEX_DIGIT ENDP


END MAIN

