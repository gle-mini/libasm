; ft_list_push_front.s
; Function: void ft_list_push_front(t_list **begin_list, void *data)
; Input:
;    RDI = pointer to the head pointer (t_list **)
;    RSI = data pointer to store in the new node
; Uses:
;    malloc – to allocate 16 bytes for a new node
; t_list structure:
;    offset 0: data (8 bytes)
;    offset 8: next (8 bytes)

section .text
    global ft_list_push_front
    extern malloc

ft_list_push_front:
    push rbx                ; save RBX (callee-saved)
    push r12                ; save R12 (we'll use it to hold begin_list)
    mov r12, rdi            ; r12 = pointer to begin_list
    mov rdi, 16             ; allocate 16 bytes (size of t_list)
    call malloc wrt ..plt             ; new node pointer in RAX (or 0 on failure)
    test rax, rax
    je .done                ; if allocation failed, do nothing
    mov rbx, rax            ; rbx = new node pointer
    ; new->data = data (second parameter, RSI)
    mov [rbx], rsi
    ; new->next = *begin_list
    mov rcx, [r12]         ; use r12 which holds the begin_list pointer
    mov [rbx+8], rcx
    ; update head pointer: *begin_list = new node
    mov [r12], rbx
.done:
    pop r12
    pop rbx
    ret
