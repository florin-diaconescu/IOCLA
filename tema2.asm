;Diaconescu Florin, 322CB

extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

;----------------------TASK1-------------------------
xor_strings:
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]  ;encoded_string
        mov ebx, [ebp + 12] ;key

;pentru fiecare byte din string-ul codificat, fac xor
;cu cate un byte din cheie, pana ajung la null(0x00)
        
xor_one_byte:
        mov cl, byte [eax]
        mov dl, byte [ebx]
        xor cl, dl
        mov byte [eax], cl
        inc eax
        inc ebx
        cmp byte [eax], 0x00
        jne xor_one_byte
        
end_task1:
        leave
        ret

;-----------------------TASK2---------------------
rolling_xor:
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8] ;encoded_string
        
        xor ebx, ebx
;determin lungimea lui eax
sizeof_string2:
        inc ebx
        cmp byte [eax + ebx - 1], 0x00
        jne sizeof_string2

;vreau sa incep rolling xor-ul de la ultimul byte         
        add eax, ebx
        sub eax, 2
        
        xor ecx, ecx
        xor edx, edx
        
;folosesc ebx pentru a stii cand am terminat de
;decodificat mesajul, deci de lungimea sirului
        sub ebx, 2
        
;loop pentru a face rolling xor, suprascriind 
;mesajul initial
roll_one_byte:
        mov cl, byte [eax]
        mov dl, byte [eax - 1]
        xor cl, dl
        mov byte [eax], cl
        dec eax
        dec ebx
        cmp ebx, 0
        jne roll_one_byte
        
end_task2:
        leave
        ret

;--------------------TASK3-------------------
xor_hex_strings:
        push ebp
        mov ebp, esp

;salvez pe stiva string-ul si cheia        
        mov eax, [ebp + 8]  ;encoded_string (in hex)
        push eax 
        mov ebx, [ebp + 12] ;key in hex
        push ebx 
        
        mov edi, eax
        xor ecx, ecx

;convertesc string-ul la o valoare decimala, intre 0 si 15(F)        
convert_string:
        mov cl, byte [eax]
        cmp cl, 57 ;codul ASCII pentru '9'
        jle is_number
        sub cl, 'a';valoare - 'a' + 10
        add cl, 10
        jmp next_byte
        
is_number:
        sub cl, 48 ;ca sa aduc la o valoare intre 0 si 9

;acelasi lucru si pentru urmatorul byte        
next_byte:
        mov dl, byte [eax + 1]
        cmp dl, 57
        jle is_number2
        sub dl, 'a'
        add dl, 10
        jmp binary_string
        
is_number2:
        sub dl, 48

;inmultesc primul byte cu 16, rezultat la care
;il adun pe cel de-al doilea, iar mai apoi repet
;acest procedeu de conversie pana ajung la 0x00        
binary_string:
        shl cl, 4
        add cl, dl
        mov byte [edi], cl
        inc edi
        add eax, 2
        cmp byte [eax], 0x00
        jne convert_string
        
        mov byte [edi], 0x00
        mov esi, ebx
        xor ecx, ecx

;acelasi procedeu pentru convertirea cheii        
convert_key:
        mov cl, byte [ebx]
        cmp cl, 57
        jle is_number_k
        sub cl, 'a'
        add cl, 10
        jmp next_byte_k
        
is_number_k:
        sub cl, 48
        
next_byte_k:
        mov dl, byte [ebx + 1]
        cmp dl, 57
        jle is_number_k2
        sub dl, 'a'
        add dl, 10
        jmp binary_key
        
is_number_k2:
        sub dl, 48
        
binary_key:
        shl cl, 4
        add cl, dl
        mov byte [esi], cl
        inc esi
        add ebx, 2
        cmp byte [ebx], 0x00
        jne convert_key
        
        mov byte [esi], 0x00
        
        pop ebx
        pop eax

;dupa ce le-am convertit in binar, pot sa fac
;xor in acelasi mod ca la task-ul 1            
xor_another_byte:
        mov cl, byte [eax]
        mov dl, byte [ebx]
        xor cl, dl
        mov byte [eax], cl
        inc eax
        inc ebx
        cmp byte [eax], 0x00
        jne xor_another_byte

end_task3:
        leave        
        ret

;-------------------------TASK4-------------------------
base32decode:
	; TODO TASK 4
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8] ;encoded_key

;determin lungimea mesajului        
        push ecx
        call strlen 
        pop ecx

;in eax vreau sa am numarul de repetari din decode_loop        
        dec eax
        shr eax, 3
        
;in esi voi salva mesajul decodificat, byte cu byte 
        xor esi, esi
        mov esi, ecx

;in acest loop, iau 8 litere din alfabetul base32, le aduc
;inapoi in forma reprezentata pe 5 biti, apoi printr-o 
;succesiune de shiftari pe biti si operatii or (pentru a
;concatena cate 8 biti) ii aduc la o forma ce poate fi folosita
;pentru decodificare. loop-ul se repeta pana cand nu mai sunt
;astfel de grupari de 8 litere, padding-ul fiind ignorat        
decode_loop:
        xor ebx, ebx
        mov bl, byte [ecx]
        cmp bl, 'A' ; mai mic, inseamna cifra sau =
        jl decode_number
        sub bl, 65 ;pentru trecerea in alfabetul base32
        jmp get_second
        
decode_number:
        sub bl, 24
        
get_second:
        xor edx, edx
        shl bl, 3
        mov dl, byte [ecx + 1]
        cmp dl, 'A'
        jl decode_number_2
        sub dl, 65
        jmp get_third
        
decode_number_2:
        sub dl, 24
        
get_third:
        push edx
        shr dl, 2
        or ebx, edx ;am primul byte
        mov byte [esi], bl
        inc esi
        xor edx, edx
        pop edx ;restaurez edx
        shl dl, 6
        mov bl, byte [ecx + 2]
        cmp bl, 'A'
        jl decode_number_3
        sub bl, 65
        jmp get_fourth
        
decode_number_3:
        sub bl, 24
        
get_fourth:
        shl bl, 1
        or dl, bl
        mov bl, byte [ecx + 3]
        cmp bl, 'A'
        jl decode_number_4
        sub bl, 65
        jmp get_fifth
        
decode_number_4:
        sub bl, 24
        
get_fifth:
        push ebx
        shr bl, 4
        or dl, bl ;inca un byte
        mov byte [esi], dl
        inc esi
        pop ebx
        shl bl, 4
        xor edx, edx
        mov dl, byte [ecx + 4]
        cmp dl, 'A'
        jl decode_number_5
        sub dl, 65
        jmp get_sixth
        
decode_number_5:
        cmp dl, '='
        je is_equal_5
        sub dl, 24
        jmp get_sixth
        
is_equal_5:
        xor edx, edx
        
get_sixth:
        push edx
        shr dl, 1
        or bl, dl ;inca un byte
        mov byte [esi], bl
        inc esi
        pop edx
        shl dl, 7
        xor ebx, ebx
        mov bl, byte [ecx + 5]
        cmp bl, 'A'
        jl decode_number_6
        sub bl, 65
        jmp get_seventh
        
decode_number_6:
        cmp bl, '='
        je is_equal_6
        sub bl, 24
        jmp get_seventh
        
is_equal_6:
        xor ebx, ebx

get_seventh:
        shl bl, 2
        or dl, bl
        xor ebx, ebx
        mov bl, byte [ecx + 6]
        cmp bl, 'A'
        jl decode_number_7
        sub bl, 65
        jmp get_eigth
        
decode_number_7:
        cmp bl, '='
        je is_equal_7
        sub bl, 24
        jmp get_eigth
        
is_equal_7:
        xor ebx, ebx
        
get_eigth:
        push ebx
        shr bl, 3
        or dl, bl ;inca un byte
        mov byte [esi], dl
        inc esi
        pop ebx
        shl bl, 5
        xor edx, edx
        mov dl, byte [ecx + 7]
        cmp dl, 'A'
        jl decode_number_8
        sub dl, 65
        jmp last_get
        
decode_number_8:
        cmp dl, '='
        je is_equal_8
        sub dl, 24
        jmp last_get
        
is_equal_8:
        xor edx, edx
        
last_get:
        or bl, dl ;ultimul byte
        mov byte [esi], bl
        inc esi
        dec eax
        cmp eax, -1
        jne before_decode_loop
        je decoded_base32
        
before_decode_loop:
        add ecx, 8
        jmp decode_loop

;dupa ce mesajul a fost decodificat, adaug un 0x00 pentru
;a marca terminarea sirului        
decoded_base32:        
        mov ecx, esi
        mov byte [ecx + 1], 0x00
       
        leave
        ret

;--------------------------TASK5-------------------------
bruteforce_singlebyte_xor:
	; TODO TASK 5
        push ebp
        mov ebp, esp
     
        mov ecx, [ebp + 8] ;encoded_string

;in edx voi incerca pe rand fiecare dintre cheile posibile,
;adica intre 1 si 255  
        xor edx, edx
        mov edx, 1
        
;salvez mesajul, in cazul in care cheia nu este buna, dar si 
;cheia curenta
bruteforce:
        push edx
        xor ebx, ebx
        push ecx

;aplic cheia pe care fiecare byte al mesajului        
bruteforce_loop:
        mov bh, byte [ecx]
        mov bl, dl
        xor bh, bl
        mov byte [ecx], bh
        inc ecx
        cmp byte [ecx], 0x00
        jne bruteforce_loop
       
        pop ecx     
        push ecx

;verific daca gasesc force in mesajul decriptat,
;in caz contrar incercand sa aplic o alta cheie                
f:
        cmp byte [ecx], 0x00
        je restore_string
        xor edx, edx
        cmp byte [ecx], 'f'
        je o
        jne before_f
        
o:
        inc ecx
        inc edx
        cmp byte [ecx], 'o'
        je r
        jne before_f
        
r:
        inc ecx
        inc edx
        cmp byte [ecx], 'r'
        je c
        jne before_f
        
c:
        inc ecx
        inc edx
        cmp byte [ecx], 'c'
        je e
        jne before_f
        
e:
        inc ecx
        inc edx
        cmp byte [ecx], 'e'
        je got_the_key

before_f:
        sub ecx, edx
        inc ecx
        jmp f

;daca nu a fost gasit, restaurez mesajul original
;printr-un procedeu invers "decriptarii" nereusite        
restore_string:
        pop ecx
        pop edx
        push ecx
        
restore_string_loop:
        mov bh, byte [ecx]
        mov bl, dl
        xor bh, bl
        mov byte [ecx], bh
        inc ecx
        cmp byte [ecx], 0x00
        jne restore_string_loop
        
final_restore:
        pop ecx
        inc edx
        jmp bruteforce

;daca am gasit cheia, inseamna ca mesajul a fost
;decriptat cu succes, iar cheia va fi in eax        
got_the_key:
        pop ecx
        pop edx
        
        xor eax, eax
        mov al, dl
        leave
        ret

;---------------------------TASK6-------------------------
decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]  ;encoded_string
        mov eax, [ebp + 12] ;key
;salvez pe stiva cheia, pentru a o restaura in momentul
;duplicarii
        push eax

;verific daca fiecare byte din mesaj face parte din alfabet
;(a-z), in caz ca da scazand offset-ul cheii fata de 'a', iar
;in caz ca este scazut prea mult, inseamna ca va trebuii sa revin
;de la litera 'z', pentru a genera noua litera dupa decodificare
;(procedeu ce se executa in fix_vigenere)        
vigenere_one_byte:
        mov dl, byte [ecx]
        cmp dl, 'a'
        jl skip_key
        cmp dl, 'z'
        jg skip_key
        mov dh, byte [eax]
        sub dh, 'a'
        sub dl, dh
        cmp dl, 'a'
        jl fix_vigenere
        mov byte [ecx], dl
        jmp next_vigenere_byte
  
fix_vigenere:
        mov dh, 'z'
        mov bh, 'a'
        sub bh, dl
        sub dh, bh
        inc dh
        mov byte [ecx], dh          

;cheia trebuie incrementata, cu exceptia cazului
;in care byte-ul din mesaj nu face parte din alfabet                    
next_vigenere_byte:
        inc eax
        
skip_key:
        cmp byte [eax], 0x00
        je repeat_key
        jne final_thing

;daca s-a ajuns la 0x00, restaurez cheia initiala de pe
;stiva, pentru refolosire        
repeat_key:
        pop eax
        push eax

;vreau sa decodific urmatorul byte, daca nu am ajuns cumva
;la finalul mesajului        
final_thing:
        inc ecx
        cmp byte [ecx], 0x00
        jne vigenere_one_byte
        
        leave
        ret

;------------------MAIN-----------------------
main:
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

        push ecx
        call strlen
        pop ecx

        add eax, ecx
        inc eax

        push ecx
        push eax
        call xor_strings
        
        pop ecx
        add esp, 4
        
        push ecx
        call puts                   ;print resulting string
        add esp, 4

        jmp task_done

task2:
	; TASK 2: Rolling XOR

        push ecx
        call rolling_xor
        
        pop ecx
        
        push ecx
        call puts
        add esp, 4

        jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings

        push ecx
        call strlen
        pop ecx

        add eax, ecx
        inc eax

        push ecx
        push eax
        call xor_hex_strings
        
        pop ecx
        add esp, 4

        push ecx                     ;print resulting string
        call puts
        add esp, 4

        jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

        push ecx
        call base32decode
        
        pop ecx
        push ecx
        call puts                    ;print resulting string
        pop ecx
	
        jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

        push ecx
        call bruteforce_singlebyte_xor
        
        pop ecx
        push eax
        push ecx                    ;print resulting string
        call puts
        add esp, 4
        
        pop eax
        push eax                    ;eax = key value
        push fmtstr
        call printf                 ;print key value
        add esp, 8

        jmp task_done

task6:
	; TASK 6: decode Vignere cipher

        push ecx
        call strlen
        pop ecx

        add eax, ecx
        inc eax

        push eax
        push ecx                   ;ecx = address of input string 
        call decode_vigenere
        pop ecx
        add esp, 4

        push ecx
        call puts
        add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret