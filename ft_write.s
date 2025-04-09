; ft_write.s
; Function: ssize_t ft_write(int fd, const void *buf, size_t count)
; Input: RDI = file descriptor, RSI = buffer pointer, RDX = count
; Output: RAX = number of bytes written or -1 on error

section .text
global ft_write
extern __errno_location   ; changed from errno_location

ft_write:
    ; Check if buf is NULL and count > 0; if so, set errno to EINVAL (22) and return -1
    cmp rsi, 0         ; is buf NULL?
    jne .do_write      ; if not NULL, go do the write syscall
    cmp rdx, 0        ; if count is 0, it's acceptable
    je .do_write
    ; Otherwise, buf is NULL and count > 0: error case
    mov ecx, 22       ; EINVAL is 22
    call __errno_location wrt ..plt
    mov dword [rax], ecx
    mov rax, -1
    ret

.do_write:
    mov rax, 1        ; syscall number for write
    syscall
    cmp rax, 0
    jge .write_ok     ; if rax >= 0, no error occurred
    ; Error handling for syscall error:
    mov rcx, rax      ; rax contains -errno
    neg rcx           ; now rcx holds errno (positive error number)
    call __errno_location wrt ..plt
    mov dword [rax], ecx   ; store the error code (from ecx) into errno; you could also use rcx if you prefer
    mov rax, -1      ; ensure the function returns -1 on error
.write_ok:
    ret

section .note.GNU-stack
