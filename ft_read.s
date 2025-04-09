; ft_read.s
; Function: ssize_t ft_read(int fd, void *buf, size_t count)
; Input: RDI = file descriptor, RSI = buffer pointer, RDX = count
; Output: RAX = number of bytes read or -1 on error

section .text
global ft_read
extern __errno_location   ; changed from errno_location

ft_read:
    mov rax, 0           ; syscall number for read
    syscall
    cmp rax, 0           ; check if result is >= 0
    jge .read_ok         ; no error if rax >= 0
    ; Error handling: syscall returned an error (negative value)
    mov rcx, rax         ; rax contains -errno, store in rcx
    neg rcx              ; now rcx holds the positive error code (errno)
    call __errno_location wrt ..plt  ; get pointer to errno
    mov [rax], rcx       ; store the error code from rcx into errno
    mov rax, -1         ; ensure the function returns -1 on error
.read_ok:
    ret

section .note.GNU-stack
