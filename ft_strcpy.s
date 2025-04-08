; ft_strcpy.s
; Function: char *ft_strcpy(char *dst, const char *src)
; Input: RDI = destination pointer, RSI = source pointer
; Output: RAX = original destination pointer

section .text
global ft_strcpy

ft_strcpy:
    push rdi             ; save original destination pointer
.copy_loop:
    mov al, [rsi]        ; load byte from source
    mov [rdi], al        ; store byte in destination
    inc rsi
    inc rdi
    test al, al          ; check for null terminator
    jnz .copy_loop
    pop rax              ; retrieve original destination pointer into RAX
    ret

section .note.GNU-stack