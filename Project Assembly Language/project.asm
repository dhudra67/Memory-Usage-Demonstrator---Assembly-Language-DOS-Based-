; Minimal Memory Usage Demonstrator (DOS-based)
; Author: M Faizan Ali
; Roll Number: 2078
;
; This program shows a simple visual representation of memory blocks

.model small
.stack 100h
.data
    ; Memory blocks (0=free, 1=used)
    memory db 10 dup(0)  ; 10 memory blocks (0=free, 1=used)
    
    ; Messages
    title_msg db "Memory Usage Demonstrator", 13, 10, "$"
    prompt_msg db 13, 10, "Enter command (a=allocate, f=free, q=quit): $"
    map_msg db 13, 10, "Memory Map: $"
    free_blk db "[ ] $"  ; Free memory block
    used_blk db "[X] $"  ; Used memory block
    newline db 13, 10, "$"

.code
main proc
    ; Initialize data segment
    mov ax, @data
    mov ds, ax
    
main_loop:
    ; Display title
    lea dx, title_msg
    mov ah, 09h
    int 21h
    
    ; Display memory map message
    lea dx, map_msg
    mov ah, 09h
    int 21h
    
    ; Show memory blocks
    call show_map
    
    ; Display prompt
    lea dx, prompt_msg
    mov ah, 09h
    int 21h
    
    ; Get command (single key)
    mov ah, 01h
    int 21h     ; Character will be in AL
    
    ; Process command
    cmp al, 'a'         ; Allocate memory
    je alloc_block
    cmp al, 'f'         ; Free memory
    je free_block
    cmp al, 'q'         ; Quit
    je exit_program
    
    ; For any other input, just loop back
    jmp main_loop

alloc_block:
    ; Find first free block and allocate it
    mov cx, 0           ; Counter
    
find_free:
    ; Check if this block is free
    mov bx, cx
    cmp memory[bx], 0
    je mark_used
    
    ; Not free, check next
    inc cx
    cmp cx, 10
    jl find_free
    
    ; No free blocks found - just return to main loop
    jmp main_loop
    
mark_used:
    ; Mark this block as used
    mov memory[bx], 1
    jmp main_loop
    
free_block:
    ; Find first used block and free it
    mov cx, 0           ; Counter
    
find_used:
    ; Check if this block is used
    mov bx, cx
    cmp memory[bx], 1
    je mark_free
    
    ; Not used, check next
    inc cx
    cmp cx, 10
    jl find_used
    
    ; No used blocks found - just return to main loop
    jmp main_loop
    
mark_free:
    ; Mark this block as free
    mov memory[bx], 0
    jmp main_loop
    
exit_program:
    ; Exit to DOS
    mov ax, 4C00h
    int 21h
    
main endp

; Show memory map - displays blocks as [ ] (free) or [X] (used)
show_map proc
    push ax
    push bx
    push cx
    push dx
    
    mov cx, 0           ; Counter
    
display_loop:
    ; Check if block is free or used
    mov bx, cx
    mov al, memory[bx]
    cmp al, 0
    je block_free
    
    ; Block is used - display [X]
    lea dx, used_blk
    jmp show_block
    
block_free:
    ; Block is free - display [ ]
    lea dx, free_blk
    
show_block:
    ; Display the block
    mov ah, 09h
    int 21h
    
    ; Next block
    inc cx
    cmp cx, 10
    jl display_loop
    
    ; Add newline
    lea dx, newline
    mov ah, 09h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
show_map endp

end main