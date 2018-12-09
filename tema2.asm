extern puts
extern printf
extern strlen
extern strstr

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

;-----------------TASK1-------------------------
xor_strings:
        ;TASK 1
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]  ;encoded_string
        mov ebx, [ebp + 12] ;key
        
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

;-------------------TASK2--------------------
rolling_xor:
	;TASK 2
        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8] ;encoded_string
        xor ebx, ebx
sizeof_string2:
        inc ebx
        cmp byte [eax + ebx - 1], 0x00
        jne sizeof_string2
        
        add eax, ebx
        sub eax, 2
        
        xor ecx, ecx
        xor edx, edx
        
        ;folosesc ebx ca sa stiu unde sa ma opresc
        sub ebx, 2
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
	;TASK 3

        push ebp
        mov ebp, esp
        
        mov eax, [ebp + 8]  ;encoded_string in hex
        push eax ;salvez pe stiva inceputul string
        mov ebx, [ebp + 12] ;key in hex
        push ebx ;salvez pe stiva inceputul cheii
        
        mov edi, eax
        xor ecx, ecx
        
convert_string:
        mov cl, byte [eax]
        cmp cl, 57 ;ASCII code for 9
        jle is_number
        sub cl, 'a';valoare - 'a' + 10
        add cl, 10
        jmp next_byte
        
is_number:
        sub cl, 48 ;ca sa aduc la o val 0-9
        
next_byte:
        mov dl, byte [eax + 1]
        cmp dl, 57
        jle is_number2
        sub dl, 'a'
        add dl, 10
        jmp binary_string
        
is_number2:
        sub dl, 48
        
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

;--------------------TASK4-------------------------
base32decode:
	; TODO TASK 4
	ret

;--------------------TASK5-------------------------
bruteforce_singlebyte_xor:
	; TODO TASK 5
        push ebp
        mov ebp, esp
     
        mov ecx, [ebp + 8]
  
        xor edx, edx
        mov edx, 1
bruteforce:
        push edx
        xor ebx, ebx
        push ecx
        
bruteforce_loop:
        mov bh, byte [ecx]
        mov bl, dl
        xor bh, bl
        mov byte [ecx], bh
        inc ecx
        cmp byte [ecx], 0x00
        jne bruteforce_loop
       
        pop ecx
labely:      
        push ecx
                
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
        
restore_string:
        pop ecx
        pop edx
        push ecx
        ;cmp dl, 0xFF
        ;je got_the_key
        
restore_string_loop:
        mov bh, byte [ecx]
        mov bl, dl
        xor bh, bl
        mov byte [ecx], bh
        inc ecx
        cmp byte [ecx], 0x00
        jne restore_string_loop
        je final_restore
        
final_restore:
        pop ecx
        inc edx
        jmp bruteforce
        
got_the_key:
        pop ecx
        pop edx
        
        xor eax, eax
        mov al, dl
        leave
        ret

;--------------------TASK6-------------------------
decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]  ;string-ul
        mov eax, [ebp + 12] ;cheia
        push eax
        
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
                    
next_vigenere_byte:
        inc eax
        
skip_key:
        cmp byte [eax], 0x00
        je repeat_key
        jne final_thing
        
repeat_key:
        pop eax
        push eax
        
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

	;find the address for the string and the key
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

	; TODO TASK 2: call the rolling_xor function
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

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
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

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

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
