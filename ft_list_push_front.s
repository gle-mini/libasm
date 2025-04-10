; Define the t_list structure constants if not already defined.
%define t_list_size 16    ; 16 bytes for a node (2 pointers, 8 bytes each)
%define t_list.data 0     ; offset 0 for data
%define t_list.next 8     ; offset 8 for next pointer

section .text
    global ft_create_elem
    global ft_list_push_front
    extern malloc
    extern __errno_location

;----------------------------------------------------------------------------
; ft_create_elem
; Creates a new list node.
;
; Input:
;   RDI = pointer to the data to be stored in the new node.
; Output:
;   RAX = pointer to the new node or 0 on failure.
;
; On failure, it calls __errno_location and sets errno to ENOMEM (12).
;----------------------------------------------------------------------------
ft_create_elem:
    ; Save the original data pointer
    push    rdi

    ; Allocate memory for the new node (16 bytes)
    mov     rdi, t_list_size
    call    malloc wrt ..plt
    pop     rdi              ; restore the data pointer

    test    rax, rax
    jz      .enomem         ; if malloc returned 0, jump to error

    ; Initialize the node:
    ; Store the data pointer at offset 0 of the node.
    mov     qword [rax + t_list.data], rdi
    ; Set the next pointer to 0 (NULL).
    mov     qword [rax + t_list.next], 0
    ret

.enomem:
    ; Call __errno_location to get the pointer to errno.
    call    __errno_location wrt ..plt
    ; Set errno to ENOMEM (12)
    mov     byte [rax], 12
    xor     rax, rax       ; return 0 to indicate failure.
    ret

;----------------------------------------------------------------------------
; ft_list_push_front
; Adds a new node at the beginning of the linked list.
;
; Input:
;   RDI = pointer to the head pointer (t_list **)
;   RSI = data pointer to store in the new node.
;----------------------------------------------------------------------------
ft_list_push_front:
    ; If the pointer to the list (begin_list) is NULL, do nothing.
    test    rdi, rdi
    jz      .done

    ; Create a new node with the data.
    push    rdi            ; save the pointer to the head pointer
    mov     rdi, rsi       ; set the data pointer as the argument for ft_create_elem
    call    ft_create_elem
    pop     rdi            ; restore the pointer to the head pointer
    test    rax, rax
    jz      .done          ; if node creation failed, return

    ; rax now contains the pointer to the new node.
    ; Link the new node into the list:
    mov     rsi, [rdi]     ; load current head pointer
    mov     qword [rax + t_list.next], rsi  ; new->next = current head
    mov     qword [rdi], rax ; update head pointer to point to the new node

.done:
    ret
