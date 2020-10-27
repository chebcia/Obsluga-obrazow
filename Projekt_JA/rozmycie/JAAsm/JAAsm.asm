.data
red_mult qword 0.11
green_mult qword 0.5870
blue_mult qword 0.2989

.code
_TEXT SEGMENT

_DllMainCRTStartup PROC 

mov        RAX, 1 
ret

_DllMainCRTStartup ENDP
MyProc1 PROC
    mov r10, 0 ; licznik 
    mov r11, rbx ;  zapis 
    mov r9, rdx ; d³ugoœæ
    mov r8, rcx ;  array
    mov rbx, 4  ; ilosc channeli
    mov r12, 0 ; avg
    jmp b_w_end_loop

b_w_loop:
		push r10
        movzx eax, byte ptr[r8 + r10] ; nie ma interpetowac tego co jest w srodku i ma je zastapic 0 
        cvtsi2sd xmm0, eax ; zerowy rejestr od tego ful
        mulsd xmm0, qword ptr red_mult  ; wysze bity 64 qword, mulsd - rozszerzenie na obliczeniach na zmiennoprzecinkowych
        inc r10

        movzx eax, byte ptr[r8 + r10]
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr green_mult
        addsd xmm0, xmm1
        inc r10

        movzx eax, byte ptr[r8 + r10]
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr blue_mult
        addsd xmm0, xmm1

        cvttsd2si r12, xmm0 ; double na integery i przypisanie do r12
		pop r10

    mov byte ptr[r8 + r10], r12b ; najnisze 8 bitow
    inc r10  
    mov byte ptr[r8 + r10], r12b
    inc r10
    mov byte ptr[r8 + r10], r12b
    add r10, 2

b_w_end_loop:
    cmp r10, r9
    jl b_w_loop
    mov rbx, r11
    ret

MyProc1 ENDP
_TEXT ENDS
end