; ft_write.s
; Function: ssize_t ft_write(int fd, const void *buf, size_t count)
; Input: RDI = file descriptor, RSI = buffer pointer, RDX = count
; Output: RAX = number of bytes written or -1 on error

section .text
global ft_write
extern __errno_location   ; changed from errno_location

ft_write:
    mov rax, 1           ; syscall number for write
    syscall
    cmp rax, -1
    jne .write_ok
    ; Error handling: syscall returned an error, save error code.
    mov rcx, rax
    neg rcx              ; make error positive
    call __errno_location  ; get pointer to errno variable in RAX
    mov [rax], ecx       ; store error number in errno
    mov rax, -1
.write_ok:
    ret

section .note.GNU-stack