%include "io.inc"

%define MAX_INPUT_SIZE 4096
%define MAX_BUFFER_SIZE 10

section .bss
    expr: resb MAX_INPUT_SIZE
    buffer: resb MAX_BUFFER_SIZE

section .data
    length: dd 0
    current_pos: dd 0

section .text
    global CMAIN
    extern puts
    extern scanf
    
addition:
    push ebp
    mov ebp, esp
    
substraction:
    push ebp
    mov ebp, esp
    
multiplication:
    push ebp
    mov ebp, esp
    
division:
    push ebp
    mov ebp, esp

CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    GET_STRING expr, MAX_INPUT_SIZE
    mov edi, expr
    mov al, 0
    cld
    repne scasb 
    
    sub edi, expr
    
    mov [length], edi ;lungimea expresiei in length
    mov byte [current_pos], 0
    
blabel:
    mov ecx, [length]
    mov edi, expr
    add edi, [current_pos]
    
    mov esi, edi
    mov al, ' '
    cld
    repne scasb

    
    sub edi, esi
    
    push edi ;salvez edi pe stiva
    
    mov ecx, edi
    mov esi, expr
    add esi, [current_pos]
    mov edi, buffer
    cld
    rep movsb ;mut in buffer operatorul/operandul
    
    PRINT_STRING buffer ;debugging purposes
    NEWLINE
    
    pop edi ;restaurez edi
    sub [length], edi
    add [current_pos], edi
    
    cmp byte [length], 0
    
    je over
    jne blabel
    
over:
    

    xor eax, eax
    pop ebp
    ret
