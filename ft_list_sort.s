; ft_list_sort.s
; Function: void ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *))
; Input:
;    RDI = pointer to the head pointer (t_list **)
;    RSI = pointer to a cmp function (int cmp(void*, void*))
; The list is sorted by swapping only the data fields.
; t_list structure:
;    offset 0: data
;    offset 8: next

section .text
    global ft_list_sort

ft_list_sort:
    ; Check if begin_list or *begin_list is NULL.
    test rdi, rdi
    je .done
    mov rax, [rdi]
    test rax, rax
    je .done
    push rbx            ; save RBX (used for swapped flag)
    push r12            ; save R12 (to store the cmp function pointer)
    mov r12, rsi        ; r12 = cmp function pointer
.sort_outer:
    xor ebx, ebx        ; swapped flag = 0
    mov rdx, [rdi]      ; rdx = head of list
.sort_inner:
    mov r8, [rdx+8]     ; r8 = rdx->next
    test r8, r8
    je .check_swapped
    ; Compare current->data with next->data
    mov rdi, [rdx]      ; current->data
    mov rsi, [r8]       ; next->data
    call r12            ; call cmp function: cmp(current->data, next->data)
    cmp rax, 0
    jle .no_swap
    ; Swap the data pointers if comparison > 0
    mov r10, [rdx]      ; r10 = current->data
    mov r11, [r8]       ; r11 = next->data
    mov [rdx], r11      ; current->data = next->data
    mov [r8], r10       ; next->data = old current->data
    mov ebx, 1         ; mark that a swap occurred
.no_swap:
    mov rdx, r8         ; move to the next node
    jmp .sort_inner
.check_swapped:
    cmp ebx, 0
    jne .sort_outer    ; if a swap occurred, restart from beginning
    pop r12
    pop rbx
.done:
    ret

