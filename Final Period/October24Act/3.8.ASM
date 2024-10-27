; Filename: PROG3.8.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the sum of individual digits of a number.
; Date: October 24, 2024

.MODEL SMALL
.STACK 100H
.DATA
prompt1 DB 'Enter the first number: $'
prompt2 DB 'Enter the second number: $'
result_msg DB 'The result is: $'
newline DB 0DH, 0AH, '$'
first_num DB 2, 0, 2 DUP (?)  ; Max 2 digits, with control byte initialized to 0
second_num DB 2, 0, 2 DUP (?) ; Max 2 digits, with control byte initialized to 0


.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX


    ; Prompt for the first number
    MOV DX, OFFSET prompt1
    MOV AH, 09H
    INT 21H


    ; Read the first number
    LEA DX, first_num
    MOV AH, 0AH
    INT 21H


    ; Convert the first number from ASCII to binary
    LEA SI, first_num + 2  ; Skip control bytes
    CALL convert_to_number
    MOV BX, AX              ; Store result in BX


    ; Prompt for the second number
    MOV DX, OFFSET prompt2
    MOV AH, 09H
    INT 21H


    ; Read the second number
    LEA DX, second_num
    MOV AH, 0AH
    INT 21H


    ; Convert the second number from ASCII to binary
    LEA SI, second_num + 2  ; Skip control bytes
    CALL convert_to_number
    ADD AX, BX              ; Add the two numbers


    ; Print the result message
    MOV DX, OFFSET result_msg
    MOV AH, 09H
    INT 21H


    ; Convert the result to ASCII and print
    CALL print_number


    ; New line
    MOV DX, OFFSET newline
    MOV AH, 09H
    INT 21H


    ; Terminate the program
    MOV AH, 4CH
    INT 21H


convert_to_number PROC
    XOR AX, AX            ; Clear AX to start


    ; Get the first digit


    MOV AL, [SI]          ; Get the first digit
    CMP AL, 0DH           ; Check if only one digit entered
    JE single_digit


    SUB AL, '0'           ; Convert first ASCII digit to binary
    MOV BL, 10            ; Set multiplier to 10
    MUL BL                ; AX = first digit * 10
    INC SI                ; Move to next character


single_digit:
    MOV AL, [SI]          ; Get the second (or only) digit
    CMP AL, 0DH           ; Check if it is a carriage return (end of input)
    JE finish_conversion   ; If only one digit, finish


    SUB AL, '0'           ; Convert second ASCII digit to binary
MOV AH, 0         ; Clear AH to make AX a 16-bit representation of AL
ADD AX, AX        ; Now add AL (in AX) to AX




finish_conversion:
    RET
convert_to_number ENDP


print_number PROC
    ; Print the result in AX as a decimal number
    PUSH AX               ; Save AX
    XOR CX, CX            ; Clear CX (counter for digits)


next_digit:
    XOR DX, DX            ; Clear DX
    MOV BX, 10            ; Prepare divisor (10)
    DIV BX                ; AX = AX / 10, DX = remainder (digit)
    PUSH DX               ; Push digit on stack
    INC CX                ; Increment digit count
    TEST AX, AX           ; Check if AX is 0
    JNZ next_digit        ; Repeat if there are more digits


print_digits:
    POP DX                ; Get digit from stack
    ADD DL, '0'           ; Convert binary to ASCII
    MOV AH, 02H           ; DOS interrupt to print character
    INT 21H
    DEC CX                ; Decrement counter
    JNZ print_digits      ; Repeat for all digits


    POP AX                ; Restore AX after printing
    RET
print_number ENDP


main ENDP
END main
