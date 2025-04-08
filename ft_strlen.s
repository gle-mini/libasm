; ft_strlen.s
; Function: size_t ft_strlen(const char *s)
; Input: RDI = pointer to null terminated string
; Output: RAX = length of string

section .text
global ft_strlen

ft_strlen:
    xor rax, rax           ; zero out counter (RAX)
.loop:
    cmp byte [rdi + rax], 0
    je .end
    inc rax
    jmp .loop
.end:
    ret

section .note.GNU-stack