; ft_atoi_base.s
; Function: int ft_atoi_base(char *str, char *base);
; Converts the given string number in an arbitrary base into an integer.
; It skips leading whitespace, processes an optional sign, then for each digit,
; searches for that character in the base string and updates the result accordingly.
; The base is considered invalid if its length is less than 2, or if it contains
; '+' , '-' or any whitespace characters, or if it contains duplicate characters.
; If the base is invalid, the function returns 0.
default rel
global ft_atoi_base
section .text

ft_atoi_base:
    ; Save callee-saved registers
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    ; === Base Validation ===
    mov     r12, rsi          ; r12 = pointer to base string
    xor     rcx, rcx          ; rcx = base length (counter = 0)
base_loop:
    mov     al, [r12 + rcx]
    test    al, al
    jz      base_done
    ; Reject forbidden characters: '+' , '-' and whitespace (space, tab, newline, vertical tab, form feed, carriage return)
    cmp     al, '+'
    je      invalid
    cmp     al, '-'
    je      invalid
    cmp     al, ' '
    je      invalid
    cmp     al, 9
    je      invalid
    cmp     al, 10
    je      invalid
    cmp     al, 11
    je      invalid
    cmp     al, 12
    je      invalid
    cmp     al, 13
    je      invalid

    ; Check for duplicates in already‐seen characters
    mov     rbx, 0            ; rbx = inner index
dup_loop:
    cmp     rbx, rcx
    jge     no_dup
    mov     dl, [r12 + rbx]
    cmp     dl, al
    je      invalid         ; duplicate found
    inc     rbx
    jmp     dup_loop
no_dup:
    inc     rcx             ; increment base length counter
    jmp     base_loop
base_done:
    cmp     rcx, 2
    jl      invalid         ; base length less than 2 is invalid
    mov     r14, rcx        ; r14 = base length

    ; === Input String Preprocessing ===
    ; Skip any leading whitespace in input string (rdi)
skip_inp:
    mov     al, [rdi]
    cmp     al, ' '
    je      skip_inp_inc
    cmp     al, 9
    je      skip_inp_inc
    cmp     al, 10
    je      skip_inp_inc
    cmp     al, 11
    je      skip_inp_inc
    cmp     al, 12
    je      skip_inp_inc
    cmp     al, 13
    je      skip_inp_inc
    jmp     inp_done
skip_inp_inc:
    inc     rdi
    jmp     skip_inp
inp_done:

    ; Process optional sign. Store sign in r15.
    mov     r15, 1          ; default sign is +1
    mov     bl, [rdi]
    cmp     bl, '-'
    jne     check_plus
    mov     r15, -1         ; negative sign
    inc     rdi
    jmp     sign_done
check_plus:
    cmp     bl, '+'
    jne     sign_done
    inc     rdi
sign_done:

    ; === Conversion Loop ===
    xor     rdx, rdx        ; rdx will hold the accumulated result (initialize to 0)
conv_loop:
    mov     al, [rdi]       ; load current character from input
    test    al, al
    jz      conv_done     ; if 0 terminator, conversion is complete

    ; Search for the current character in the base string.
    xor     r8, r8        ; r8 will be the digit value (index into the base)
find_digit:
    cmp     r8, r14
    jae     conv_done     ; if index reached base length without match, stop conversion
    mov     bl, [r12 + r8] ; load base[r8]
    cmp     al, bl
    je      digit_found
    inc     r8
    jmp     find_digit
digit_found:
    ; Multiply accumulated result by the base length and add the digit value.
    imul    rdx, r14      ; rdx = rdx * base_length
    add     rdx, r8       ; add digit value (r8)
    inc     rdi           ; move to next character
    jmp     conv_loop

conv_done:
    imul    rdx, r15      ; apply the sign
    mov     rax, rdx      ; move result to rax

    ; Restore registers and return.
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

invalid:
    xor     rax, rax      ; return 0 for an invalid base
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret
