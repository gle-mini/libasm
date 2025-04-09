; ft_list_size.s
; Function: int ft_list_size(t_list *begin_list)
; Input: 
;    RDI = pointer to the first node (t_list *)
; Output:
;    EAX = number of nodes in the list
; t_list structure:
;    offset 0: data
;    offset 8: next

section .text
    global ft_list_size

ft_list_size:
    xor eax, eax        ; initialize count to 0
.loop:
    test rdi, rdi       ; if pointer is NULL, end loop
    je .done
    inc eax             ; count++
    mov rdi, [rdi+8]    ; move to next node (t_list->next)
    jmp .loop
.done:
    ret

