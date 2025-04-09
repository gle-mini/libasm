; ft_list_remove_if.s
; Function: void ft_list_remove_if(t_list **begin_list, void *data_ref,
;           int (*cmp)(void *, void *), void (*free_fct)(void *))
; Input:
;    RDI = pointer to the head pointer (t_list **)
;    RSI = data_ref pointer
;    RDX = cmp function pointer (int cmp(void*, void *))
;    RCX = free_fct function pointer (void free_fct(void*))
; Uses:
;    free – external C function to free a node
; t_list structure:
;    offset 0: data
;    offset 8: next

section .text
    global ft_list_remove_if
    extern free

ft_list_remove_if:
    ; If begin_list is NULL, do nothing.
    test rdi, rdi
    je .done
    ; Save callee-saved registers we'll use:
    push rbx              ; we'll use RBX for cmp pointer
    push rbp              ; we'll use RBP for free_fct pointer
    push r12              ; save begin_list pointer
    push r13              ; save data_ref
    
    ; Store the function pointers in callee-saved registers:
    mov rbx, rdx          ; rbx = cmp function pointer
    mov rbp, rcx          ; rbp = free_fct function pointer
    ; Save begin_list pointer and data_ref:
    mov r12, rdi          ; r12 = pointer to head pointer (t_list **)
    mov r13, rsi          ; r13 = data_ref

.remove_begin:
    mov rax, [r12]        ; rax = *begin_list (current node)
    test rax, rax
    je .remove_begin_done
    ; Compare current node's data with data_ref:
    mov rdi, [rax]        ; current->data
    mov rsi, r13          ; data_ref
    call rbx              ; call cmp(current->data, data_ref)
    cmp rax, 0
    jne .remove_begin_done
    ; Node matches: remove it.
    mov r8, [rax+8]       ; r8 = current->next
    ; Call free_fct on the node's data.
    mov rdi, [rax]
    call rbp              ; call free_fct(current->data)
    ; Free the node itself.
    mov rdi, rax
    call free wrt ..plt
    ; Update head pointer: *begin_list = next node.
    mov [r12], r8
    jmp .remove_begin

.remove_begin_done:
    ; Process the remaining list.
    mov rax, [r12]        ; rax = current head of the list
    test rax, rax
    je .cleanup
    ; Set previous pointer in r14 and current pointer in r15.
    mov r14, rax          ; r14 = previous node
    mov r15, [r14+8]      ; r15 = current node = previous->next
.loop_remove:
    test r15, r15
    je .cleanup
    ; Compare current node's data with data_ref.
    mov rdi, [r15]        ; r15->data
    mov rsi, r13          ; data_ref
    call rbx              ; call cmp(r15->data, data_ref)
    cmp rax, 0
    jne .next_node
    ; Node matches: remove it.
    mov r8, [r15+8]       ; r8 = r15->next
    ; Update previous->next to bypass the current node.
    mov [r14+8], r8
    ; Call free_fct on current node's data.
    mov rdi, [r15]
    call rbp              ; call free_fct(r15->data)
    ; Free the current node.
    mov rdi, r15
    call free wrt ..plt
    ; Set current pointer to previous->next.
    mov r15, r8
    jmp .loop_remove
.next_node:
    ; Move both previous and current one node forward.
    mov r14, r15
    mov r15, [r15+8]
    jmp .loop_remove

.cleanup:
    pop r13
    pop r12
    pop rbp
    pop rbx
.done:
    ret

section .note.GNU-stack