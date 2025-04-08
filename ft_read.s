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
    cmp rax, -1
    jne .read_ok
    ; Error handling: syscall returned an error, save error code.
    mov rcx, rax
    neg rcx              ; convert error to positive code
    call __errno_location  ; get pointer to errno variable
    mov [rax], ecx       ; set errno
    mov rax, -1
.read_ok:
    ret

section .note.GNU-stack