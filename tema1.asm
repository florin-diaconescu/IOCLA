%include "io.inc"

%define MAX_INPUT_SIZE 4096
%define MAX_BUFFER_SIZE 10

section .bss
    expr: resb MAX_INPUT_SIZE
    buffer: resb MAX_BUFFER_SIZE

section .data
    length: dd 0
    current_pos: dd 0
    global_edi: dd 0

section .text
    global CMAIN
    extern puts
    extern scanf
    extern atoi
    
addition:
    pop eax
    pop edx
    add eax, edx
    
    push eax
    jmp next_op
    
substraction:
    mov ebx, buffer
    push ebx
    call atoi
    add esp, 4
    
    cmp eax, 0
    jne negative_op ;daca da, inseamna ca e operand negativ, nu operandul "-"
    
    pop edx
    pop eax
    sub eax, edx
    
    push eax
    jmp next_op
    
multiplication:
    pop edx
    pop eax
    imul edx
    
    push eax
    jmp next_op
    
division:
    xor edx, edx
    pop ecx
    cdq
    pop eax
    cdq
    idiv ecx
    
    push eax
    jmp next_op

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
    
    mov [global_edi], edi
    
    mov ecx, edi
    mov esi, expr
    add esi, [current_pos]
    mov edi, buffer
    cld
    rep movsb ;mut in buffer operatorul/operandul
    
    ;PRINT_STRING buffer ;debugging purposes
    ;NEWLINE
    
    cmp byte [buffer], 42 ;inmultire
    je multiplication
    
    cmp byte [buffer], 43 ;adunare
    je addition
    
    cmp byte [buffer], 45 ;scadere
    je substraction
    
    cmp byte [buffer], 47 ;impartire
    je division
  
    mov ebx, buffer
    push ebx
    call atoi
    add esp, 4
 
negative_op:   
    push eax
    ;add esp, 4

next_op:    
    mov edi, [global_edi] ;restaurez edi
    sub [length], edi
    add [current_pos], edi
    
    cmp byte [length], 0
    je over
    jne blabel
    
over:
    pop eax
    PRINT_DEC 4, eax

    xor eax, eax
    pop ebp
    ret