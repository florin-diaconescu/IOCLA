BITS 32
extern print_line
global mystery1:function
global mystery2:function
global mystery3:function
global mystery4:function
global mystery6:function
global mystery7:function
global mystery8:function
global mystery9:function

section .text

; SAMPLE FUNCTION
; Description: adds two integers and returns their sum
; @arg1: int a - the first number
; @arg2: int b - the second number
; Return value: int
; Suggested name: add

mystery1:
  push ebp
  mov ebp, esp

  push ebx
  mov edi, DWORD [ebp+8]
  xor eax, eax
  xor ebx, ebx
  
mystery1l1:
  mov bl, BYTE [edi]
  test ebx, ebx
  je mystery1l2
  inc eax
  inc edi
  jmp mystery1l1

mystery1l2:
  pop ebx
  leave
  ret

mystery2:
  push ebp
  mov ebp, esp

  mov edx, DWORD [ebp+8]
  push edx
  call mystery1
  add esp, 4
  mov ecx, eax
  xor eax, eax
  mov edi, DWORD [ebp+8]
  mov dl, BYTE [ebp+12]
  
mystery2l1:
  mov bl, BYTE [edi]
  cmp bl, dl
  je mystery2l2
  inc eax
  inc edi
  jmp mystery2l1

mystery2l2:
  cmp ecx, 0
  jne mystery2l3
  mov eax, 0xffffffff

mystery2l3:
  leave
  ret

mystery3:
  push ebp
  mov ebp, esp

  mov ebx, DWORD [ebp+8]
  mov edx, DWORD [ebp+12]
  mov ecx, DWORD [ebp+16]

mystery3l1:
  mov al, BYTE [ebx]
  mov ah, BYTE [edx]
  cmp al, ah
  jne mystery3l2
  inc ebx
  inc edx
  loop mystery3l1
  xor eax, eax
  jmp mystery3l3

mystery3l2:
  mov eax, 1

mystery3l3:
  leave
  ret

mystery4:
  push ebp
  mov ebp, esp

  push ebx
  mov eax, DWORD [ebp+8]
  mov ebx, DWORD [ebp+12]
  mov ecx, DWORD [ebp+16]

mystery4l1:
  mov dl, BYTE [ebx]
  mov BYTE [eax], dl
  inc eax
  inc ebx
  loop mystery4l1
  pop ebx

  leave
  ret

mystery5:
  push ebp
  mov ebp, esp

  mov eax, DWORD [ebp+8]
  cmp al, 0x30
  jl mystery5l1
  cmp al, 0x39
  jg mystery5l1
  mov eax, 1
  jmp mystery5l2

mystery5l1:
  xor eax, eax

mystery5l2:
  leave
  ret

mystery6:
  push ebp
  mov ebp, esp

  mov edi, DWORD [ebp+8]
  push edi
  call mystery1
  add esp, 4
  mov edi, DWORD [ebp+8]
  mov ecx, eax
  sub esp, eax
  mov ebx, ebp
  sub ebx, eax

mystery6l1:
  mov dl, BYTE [edi+ecx*1-1]
  mov BYTE [ebx], dl
  inc ebx
  loop mystery6l1
  push eax
  mov ebx, ebp
  sub ebx, eax
  push ebx
  push edi
  call mystery4
  add esp, 12
  leave
  ret

mystery7:
  push ebp
  mov ebp, esp

  xor edx, edx
  xor ebx, ebx
  mov eax, DWORD [ebp+8]
  sub esp, 4
  mov DWORD [ebp-4], 0
  push eax
  call mystery1
  add esp, 4
  mov ecx, eax
  push eax
  push ebx
  push ecx
  push edx
  push edi
  mov esi, DWORD [ebp+8]
  push esi
  call mystery6
  add esp, 4
  pop edi
  pop edx
  pop ecx
  pop ebx
  pop eax

mystery7l1:
  mov bl, BYTE [esi+ecx*1-1]
  push ebx
  push ebx
  call mystery5
  add esp, 4
  cmp eax, 0
  je mystery7l3
  pop ebx
  sub bl, 0x30
  push ebx
  mov ebx, 0xa
  mov eax, DWORD [ebp-4]
  mul ebx
  pop ebx
  add eax, ebx
  mov DWORD [ebp-4], eax
  loop mystery7l1
  jmp mystery7l2

mystery7l3:
  mov eax, 0xffffffff
  add esp, 4

mystery7l2:
  leave
  ret

mystery8:
  push ebp
  mov ebp, esp

  sub esp, 0x10
  mov DWORD [ebp-4], 0x0
  mov DWORD [ebp-8], 0x0

mystery8l1:
  mov eax, DWORD [ebp-0x8]
  cmp eax, DWORD [ebp+0x10]
  jae mystery8l2
  mov edx, DWORD [ebp+8]
  mov eax, DWORD [ebp-4]
  add eax, edx
  mov al, BYTE [eax]
  cmp al, 0xa
  je mystery8l2
  mov edx, DWORD [ebp+8]
  mov eax, DWORD [ebp-4]
  add eax, edx
  mov al, BYTE [eax]
  test al, al
  je mystery8l2
  mov edx, DWORD [ebp+8]
  mov eax, DWORD [ebp-4]
  add eax, edx
  mov dl, BYTE [eax]
  mov ecx, DWORD [ebp+12]
  mov eax, DWORD [ebp-8]
  add eax, ecx
  mov al, BYTE [eax]
  cmp dl, al
  je mystery8l3
  mov DWORD [ebp-8], 0
  jmp mystery8l4

mystery8l3:
  inc DWORD [ebp-8]

mystery8l4:
  mov eax, DWORD [ebp-0x8]
  cmp eax, DWORD [ebp+0x10]
  jne mystery8l5
  mov eax, 1
  jmp mystery8l6

mystery8l5:
  inc DWORD [ebp-4]
  jmp mystery8l1

mystery8l2:
  xor eax, eax

mystery8l6:
  leave
  ret

mystery9:
  push ebp
  mov ebp, esp

  sub esp, 0x18
  mov DWORD [ebp-12], 0
  mov eax, DWORD [ebp+12]
  mov DWORD [ebp-0x10], eax
  push DWORD [ebp+0x14]
  call mystery1
  add esp, 4
  mov DWORD [ebp-0x14], eax
  mov eax, DWORD [ebp+0xc]
  mov DWORD [ebp-0xc], eax
  
mystery9l1:
  mov eax, DWORD [ebp-0xc]
  cmp eax, DWORD [ebp+0x10]
  jae mystery9l2
  mov edx, DWORD [ebp+8]
  mov eax, DWORD [ebp-12]
  add eax, edx
  mov al, BYTE [eax]
  cmp al, 0xa
  jne mystery9l3
  mov edx, DWORD [ebp+0x8]
  mov eax, DWORD [ebp-0x10]
  add eax, edx
  push DWORD [ebp-0x14]
  push DWORD [ebp+0x14]
  push eax
  call mystery8
  add esp, 0xc
  test eax, eax
  setne al
  test al, al
  je mystery9l4
  mov edx, DWORD [ebp+0x8]
  mov eax, DWORD [ebp-0x10]
  add eax, edx
  sub esp, 0xc
  push eax
  call print_line
  add esp, 0x10

mystery9l4:
  mov eax, DWORD [ebp-0xc]
  inc eax
  mov DWORD [ebp-0x10], eax

mystery9l3:
  inc DWORD [ebp-0xc]
  jmp mystery9l1

mystery9l2:
  leave
  ret
