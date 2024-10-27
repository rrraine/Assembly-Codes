; Filename: PROG3.6.ASM
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
    hex_table   DB '0123456789ABCDEF'        ; Lookup table for hexadecimal digits


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


    ; Print the hexadecimal equivalent using XLAT
    MOV AH, AL            ; Copy the ASCII code into AH
    SHR AL, 4             ; Shift right to get the high nibble in AL
    MOV BX, OFFSET hex_table ; Load address of hex_table
    XLAT                  ; Convert high nibble to hex character
    MOV DL, AL           ; Move hex character to DL for printing
    MOV AH, 02H          ; DOS function to print a single character
    INT 21H              ; Print high nibble


    ; Convert and print the lower nibble
    MOV AL, char_input    ; Load the original character back into AL
    AND AL, 0FH           ; Mask to get the lower nibble
    MOV BX, OFFSET hex_table ; Load address of hex_table
    XLAT                  ; Convert low nibble to hex character
    MOV DL, AL           ; Move hex character to DL for printing
    MOV AH, 02H          ; DOS function to print a single character
    INT 21H              ; Print low nibble


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

END MAIN
