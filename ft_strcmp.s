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
    test al, al          ; if al is 0 then strings are identical
    je .end
    inc rdi
    inc rsi
    jmp .compare_loop
.difference:
    movzx eax, al        ; zero-extend to int
    movzx ebx, bl
    sub eax, ebx
.end:
    ret

section .note.GNU-stack