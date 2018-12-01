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

bruteforce_singlebyte_xor:
	; TODO TASK 5
	ret

decode_vigenere:
	; TODO TASK 6
	ret

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
        xor eax, eax
sizeof_string:
        inc eax
        cmp byte [ecx + eax - 1], 0x00
        jne sizeof_string
        
	;call the xor_strings function
        push ecx
        add eax, ecx
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

        xor eax, eax
sizeof_string3:
        inc eax
        cmp byte [ecx + eax - 1], 0x00
        jne sizeof_string3

        push ecx
        add eax, ecx
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

	push ecx                    ;print resulting string
	call puts
	pop ecx

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
