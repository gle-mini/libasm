; ft_strdup.s
; Function: char *ft_strdup(const char *s)
; Uses: ft_strlen and ft_strcpy; calls external malloc.
; Input: RDI = pointer to the source string
; Output: RAX = pointer to the duplicated string or NULL if allocation fails

section .text
global ft_strdup
extern ft_strlen
extern ft_strcpy
extern malloc

ft_strdup:
    ; Save original string pointer in RBX
    mov rbx, rdi
    call ft_strlen       ; length returned in RAX (without null terminator)
    inc rax              ; add 1 for the null terminator
    mov rdi, rax         ; set size as argument for malloc
    call malloc wrt ..plt; malloc(size), pointer returned in RAX
    test rax, rax
    jz .return_null      ; return NULL if allocation failed
    ; Copy the original string into allocated memory.
    mov rdi, rax         ; destination (newly allocated memory)
    mov rsi, rbx         ; source string pointer
    call ft_strcpy
    ret
.return_null:
    xor rax, rax
    ret

section .note.GNU-stack
