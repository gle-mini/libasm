; ft_strcmp.s
; Function: int ft_strcmp(const char *s1, const char *s2)
; Input: RDI = pointer to s1, RSI = pointer to s2
; Output: RAX = difference between the first differing characters (or 0 if equal)

section .text
global ft_strcmp

ft_strcmp:
.compare_loop:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, bl
    jne .difference
    test al, al           ; if al == 0, then end of string reached (strings are identical)
    je .return_zero
    inc rdi
    inc rsi
    jmp .compare_loop

.difference:
    movsx eax, al         ; sign-extend AL to EAX
    movsx ebx, bl         ; sign-extend BL to EBX
    sub eax, ebx          ; compute the signed difference
    ret

.return_zero:
    xor eax, eax          ; zero out EAX (return 0)
    ret
