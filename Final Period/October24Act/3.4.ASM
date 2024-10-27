; Filename: PROG3.4.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the binary equivalent of the ASCII code of a character.
; Date: October 24, 2024

.MODEL SMALL
.STACK 100H
.DATA
    char_prompt DB 0AH,'Please input a character: $'
    out_msg1 DB 'The ASCII code of ''$'
    out_msg2 DB "', in binary is $"
    query_msg DB 'Do you want to quit (Y/N): $'
    char_input DB ?  ; Variable to store character input


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


    ; Load character input into BL for binary conversion
    MOV BL, char_input    ; Copy char_input to BL to keep it unchanged


    ; Initialize mask in BH
    MOV BH, 80H           ; Start with leftmost bit mask (10000000b)
    MOV CX, 8             ; Loop for 8 bits


print_bit:
    TEST BL, BH           ; Test if the current bit in BL is 1
    JZ print_0            ; If 0, jump to print_0
    MOV DL, '1'           ; Otherwise, print '1'
    JMP skip_print


print_0:
    MOV DL, '0'           ; Print '0'


skip_print:
    MOV AH, 02h
    INT 21h               ; Display the character in DL
    SHR BH, 1             ; Shift mask to the right for next bit
    LOOP print_bit


    ; New line
    MOV AH, 02h
    MOV DL, 0Dh           ; Carriage return
    INT 21h
    MOV DL, 0Ah           ; Line feed
    INT 21h


    ; Display query_msg message
    MOV DX, OFFSET query_msg
    MOV AH, 09h
    INT 21h


    ; Get response from user
    MOV AH, 01h           ; Function to read a character
    INT 21h               ; Read response into AL


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

