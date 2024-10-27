; Filename: PROG3.8.ASM
; Programmer Name: Lorraine B. Quezada
; Program Description: This program prints the sum of individual digits of a number.
; Date: October 24, 2024

; TITLE Add individual digits of a number ADDIGITS.ASM
; Objective: To find the sum of individual digits of a given number.
;            Shows character to binary conversion of digits.
; Input: Requests a number from keyboard.
; Output: Prints the sum of the individual digits.

.MODEL SMALL
.STACK 100H
.DATA
prompt1 DB 'Enter the first number: $'
prompt2 DB 'Enter the second number: $'
result_msg DB 'The result is: $'
newline DB 0DH, 0AH, '$'
first_num DB 2, ?, 2 DUP (?)  ; Initialize for max 2 digits
second_num DB 2, ?, 2 DUP (?) ; Initialize for max 2 digits

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
    LEA DX, first_num + 2  ; Skip control bytes
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
    LEA DX, second_num + 2  ; Skip control bytes
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
    ; Convert 2-digit ASCII number to binary
    XOR AX, AX            ; Clear AX

    ; Get the first digit
    MOV AL, [DX]          ; Get the first digit
    CMP AL, 0DH           ; Check if only one digit entered
    JE single_digit

    SUB AL, '0'           ; Convert first ASCII digit to binary
    MOV BL, 10            ; Set multiplier to 10
    MUL BL                ; AX = first digit * 10
    INC DX                ; Move to next character

single_digit:
    MOV AL, [DX]          ; Get the second (or only) digit
    CMP AL, 0DH           ; Check if it is a carriage return (end of input)
    JE finish_conversion   ; If only one digit, finish

    SUB AL, '0'           ; Convert to binary
    ADD AX, AL            ; Add to previous value

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
