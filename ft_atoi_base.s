;-----------------------------------------------------------
; ft_atoi_base: converts a string (with optional whitespace and sign)
; representing a number in base 'str_base' to its integer value.
;
; C prototype:
;   int ft_atoi_base(const char *str, int str_base);
;
; System V AMD64 (Linux) calling convention:
;   - Parameter 1 (const char *str) is in RDI.
;   - Parameter 2 (int str_base) is in RSI.
;   - Return value is in RAX.
;
; The function validates that the base is between 2 and 16.
; It skips whitespace, accepts an optional '+' or '-' sign,
; converts valid digit characters (0-9, a-f, A-F) until an invalid
; character is encountered, and returns the result.
;-----------------------------------------------------------

global ft_atoi_base
section .text

ft_atoi_base:
    ; preserve callee-saved registers (here, RBX)
    push    rbx

    ; In 64-bit mode:
    ;   RDI holds the pointer to the string.
    ;   RSI holds the base.
    ; We copy the base into RCX for comparisons and use later.
    mov     rcx, rsi

    ; Check if the base is valid (base must be >= 2 and <= 16)
    cmp     rcx, 2
    jl      invalid_base
    cmp     rcx, 16
    jg      invalid_base

    ;------------------------------------
    ; Skip leading whitespace (space, tab, newline,
    ; vertical tab, form feed, carriage return)
    ;------------------------------------
skip_ws:
    mov     al, byte [rdi]
    cmp     al, ' '
    je      inc_ws
    cmp     al, 9
    je      inc_ws
    cmp     al, 10
    je      inc_ws
    cmp     al, 11
    je      inc_ws
    cmp     al, 12
    je      inc_ws
    cmp     al, 13
    je      inc_ws
    jmp     done_ws
inc_ws:
    inc     rdi
    jmp     skip_ws
done_ws:

    ;------------------------------------
    ; Check for an optional sign:
    ;   If '-' then sign is -1; if '+' then sign is positive.
    ;------------------------------------
    mov     al, byte [rdi]
    mov     rbx, 1         ; default sign is positive
    cmp     al, '-'
    jne     check_plus
    mov     rbx, -1
    inc     rdi
    jmp     cont_sign
check_plus:
    cmp     al, '+'
    jne     cont_sign
    inc     rdi
cont_sign:

    ; Clear result in RAX (which will store the integer result)
    xor     rax, rax

    ;------------------------------------
    ; Loop to convert the string:
    ;  - For digits '0' to '9': digit = ch - '0'
    ;  - For lowercase 'a' to 'z': digit = ch - 'a' + 10
    ;  - For uppercase 'A' to 'Z': digit = ch - 'A' + 10
    ;
    ; Stop conversion if the character is not valid,
    ; or if its value is equal to or greater than the base.
    ;------------------------------------
convert_loop:
    mov     al, byte [rdi]      ; get current character
    cmp     al, 0
    je      conversion_done     ; end of string

    ; Initialize RDX with -1 (an invalid marker)
    mov     rdx, -1

    ; Check if the character is a digit ('0' to '9')
    cmp     al, '0'
    jl      check_alpha       ; if less than '0', try letters
    cmp     al, '9'
    jg      check_alpha       ; if greater than '9', try letters
    movzx   rdx, al
    sub     rdx, '0'
    jmp     got_digit

check_alpha:
    ; Check for lowercase letters ('a' to 'z')
    cmp     al, 'a'
    jl      check_upper       ; if less than 'a', try uppercase
    cmp     al, 'z'
    jg      check_upper
    movzx   rdx, al
    sub     rdx, 'a'
    add     rdx, 10          ; 'a' maps to 10, 'b' to 11, etc.
    jmp     got_digit

check_upper:
    ; Check for uppercase letters ('A' to 'Z')
    cmp     al, 'A'
    jl      exit_loop         ; if not a valid digit, exit loop
    cmp     al, 'Z'
    jg      exit_loop         ; if beyond 'Z', exit loop
    movzx   rdx, al
    sub     rdx, 'A'
    add     rdx, 10

got_digit:
    ; If the digit value is not less than the base, exit conversion.
    cmp     rdx, rcx
    jae     exit_loop

    ; Multiply current result (RAX) by base (RCX) and add the digit (RDX)
    imul    rax, rcx
    add     rax, rdx

    ; Move to the next character
    inc     rdi
    jmp     convert_loop

exit_loop:
conversion_done:
    ; Apply the detected sign (stored in RBX) to the result.
    imul    rax, rbx

    ; Restore RBX and return. The result is in RAX.
    pop     rbx
    ret

invalid_base:
    ; If the base was invalid, return 0.
    xor     rax, rax
    pop     rbx
    ret
