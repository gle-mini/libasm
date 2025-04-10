; ft_list_sort.s
; Function: void ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *))
; The list is sorted by swapping only the data fields.
; t_list structure:
;    offset 0: data
;    offset 8: next
section .text
global ft_list_sort

ft_list_sort:
    ; Check if begin_list or *begin_list is NULL.
    test    rdi, rdi
    je      .done
    mov     rax, [rdi]
    test    rax, rax
    je      .done

    ; Save callee-saved registers (we now also need to preserve R14).
    push    rbx              ; for swapped flag
    push    r12              ; to hold cmp function pointer
    push    r13              ; temporary storage for swap
    push    r14              ; temporary storage for "next" pointer

    mov     r12, rsi         ; r12 = cmp function pointer

.sort_outer:
    xor     ebx, ebx         ; clear swapped flag (ebx)
    mov     rdx, [rdi]       ; start from list head

.sort_inner:
    mov     r8, [rdx+8]      ; r8 = current node’s next pointer
    test    r8, r8
    je      .check_swapped   ; if next is NULL, inner loop is done

    mov     r14, r8          ; save "next" pointer in callee-saved R14
    ; Set up parameters for cmp: compare current->data and next->data.
    mov     rdi, [rdx]       ; rdi = current->data
    mov     rsi, [r8]        ; rsi = next->data
    call    r12              ; call cmp(current->data, next->data)
    cmp     rax, 0
    jle     .no_swap         ; if current <= next, no swap

    ; Swap the data fields:
    mov     r11, [rdx]       ; r11 = current->data
    mov     r13, [r14]       ; r13 = next->data (from saved value in R14)
    mov     [rdx], r13       ; current->data = next->data
    mov     [r14], r11       ; next->data = old current->data
    mov     ebx, 1           ; mark that a swap occurred

.no_swap:
    mov     rdx, r14         ; move to next node (r14 holds the original [rdx+8])
    jmp     .sort_inner

.check_swapped:
    cmp     ebx, 0
    jne     .sort_outer      ; if any swap occurred, restart outer loop

    pop     r14              ; restore R14
    pop     r13              ; restore R13
    pop     r12              ; restore R12
    pop     rbx              ; restore RBX
.done:
    ret
