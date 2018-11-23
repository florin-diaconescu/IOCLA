;Diaconescu Florin, 322CB

%include "io.inc"

%define MAX_INPUT_SIZE 4096
%define MAX_BUFFER_SIZE 10

;dimensiune maxima pentru buffer si input
section .bss
    expr: resb MAX_INPUT_SIZE
    buffer: resb MAX_BUFFER_SIZE

;variabile globale pentru lungimea sirului, pozitia curenta si pastrarea lui edi
section .data
    length: dd 0
    current_pos: dd 0
    global_edi: dd 0

;folosesc atoi pentru convertirea unui string in int
section .text
    global CMAIN
    extern atoi
    
;label pentru operatia de adunare, dau pop la primele 2 elemente de pe stiva, le
;adun, urmand sa sar la next_op, rezultatul fiind stocat in EAX
addition:
    pop eax
    pop edx
    add eax, edx

    jmp next_op
    
    
;label pentru operatia de scadere, in care mut buffer-ul in ebx, incerc sa-l 
;convertesc la int(in caz contrar, va returna 0), iar daca e intr-adevar vorba
;despre o scadere, scoate 2 elemente din stiva, pe care le scade si trece la
;urmatorul operator/operand, rezultatul fiind stocat in EAX
substraction:
    mov ebx, buffer
    push ebx
    call atoi
    add esp, 4
    
    cmp eax, 0
    jne next_op ;daca da, inseamna ca e operand negativ, nu operandul "-"
    
    xor eax, eax
    pop edx
    pop eax
    sub eax, edx

    jmp next_op
    
;label pentru operatia de inmultire, in care ma folosesc de imul (pot fi si numere
;negative, cu care inmultesc 2 numere extrase de pe stiva, rezultatul fiind stocat
;in EAX
multiplication:
    pop edx
    pop eax
    imul edx

    jmp next_op
    
;label pentru operatia de impartire, in care folosesc cdq pentru a dubla dimensiunea
;lui EAX (si apoi stocarea in EDX:EAX), si folosesc idiv (pot fi si numere negative),
;cu care impart doua numere extrase de pe stiva, punand rezultatul in EAX
division:
    xor edx, edx
    pop ecx
    pop eax
    cdq
    idiv ecx
    
    jmp next_op

CMAIN:
    mov ebp, esp; for correct debugging
    push ebp
    mov ebp, esp

    GET_STRING expr, MAX_INPUT_SIZE
    
    ;determin lungimea expresiei citite
    mov edi, expr
    mov al, 0
    cld
    repne scasb 
    
    sub edi, expr
    
    mov [length], edi ;lungimea expresiei in length
    mov byte [current_pos], 0 ;initializez pozitia curenta cu 0

;parserul programului, care cauta operatori/operanzi din spatiu in spatiu, apoi verifica
;in ce caz se incadreaza, pentru a fi tratat corespunzator    
parse_loop:
    ;incep cautarea pana la spatiu de la current_pos, initial 0, apoi byte-ul la care am
    ;ramas dupa ce am tratat buffer-ul precedent
    mov ecx, [length]
    mov edi, expr
    add edi, [current_pos]
    
    mov esi, edi
    mov al, ' '
    cld
    repne scasb
 
    sub edi, esi
    
    ;salvez lungimea operatorului/operandului din buffer, inainte sa verific cazurile
    mov [global_edi], edi
    
    mov ecx, edi
    mov esi, expr
    add esi, [current_pos]
    mov edi, buffer
    cld
    rep movsb ;mut in buffer operatorul/operandul, de dimensiune edi
    
    ;mai intai verific daca este operator(la scadere tratand, separat, si cazul in care
    ;dupa minus e cumva un numar(deci e numar negativ)
    cmp byte [buffer], 42 ;inmultire
    je multiplication
    
    cmp byte [buffer], 43 ;adunare
    je addition
    
    cmp byte [buffer], 45 ;scadere
    je substraction
    
    cmp byte [buffer], 47 ;impartire
    je division
  
    ;daca nu este operator, inseamna ca este operand, pe care il convertesc
    ;din string in numar, apeland functia externa atoi
    mov ebx, buffer
    push ebx
    call atoi
    add esp, 4

;dupa ce am identificat daca este operator/operand, verific daca mai am ceva
;de evaluat din expresie sau nu, actualizand variabilele auxiliare 
next_op:
    push eax    
    mov edi, [global_edi] ;restaurez edi
    sub [length], edi ;actualizez lungimea expresiei de evaluat
    ;incrementez adresa curenta de unde voi incepe apoi sa evaluez expresia
    add [current_pos], edi 
   
    
    cmp word [length], 0
    je final ;daca lungimea sirului este 0, am terminat de evaluat expresia
    jne parse_loop ;daca mai am de parsat ceva din expresie

;rezultatul va fi, la final, in EAX, pe care il afisez si restaurez stiva   
final:
    pop eax
    PRINT_DEC 4, eax

    xor eax, eax
    mov esp, ebp
    pop ebp
    ret