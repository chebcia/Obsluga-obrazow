.data
red_mult1 qword 0.393
green_mult1 qword 0.769
blue_mult1 qword 0.189

red_mult2 qword 0.349
green_mult2 qword 0.686
blue_mult2 qword 0.168

red_mult3 qword 0.272
green_mult3 qword 0.534
blue_mult3 qword 0.131





maxvalue qword 255

.code
_TEXT SEGMENT


MyProc2 PROC
    mov r10, 0 ; licznik 
    mov r11, rbx ;  zapis 
    mov r9, rdx ; d³ugoœæ
    add r8, rcx ;  array
    mov rbx, 4  ; ilosc channeli
	;add r8, rdx ; 

    jmp b_w_end_loop

b_w_loop:
        movzx eax, byte ptr[r8 + r10+2] ; nie ma interpetowac tego co jest w srodku i ma je zastapic 0 
        cvtsi2sd xmm0, eax ; zerowy rejestr od tego ful
        mulsd xmm0, qword ptr red_mult1  ; red comp
        movzx eax, byte ptr[r8 + r10 + 1] ; green
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr green_mult1
        addsd xmm0, xmm1
        movzx eax, byte ptr[r8 + r10] ; blue
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr blue_mult1
        addsd xmm0, xmm1
       
        cvttsd2si r12, xmm0
        cmp r12, 255
		jl red_ok
		mov r12, 255
red_ok:
		mov r13, r12
		

        movzx eax, byte ptr[r8 + r10+2] ; nie ma interpetowac tego co jest w srodku i ma je zastapic 0 
        cvtsi2sd xmm0, eax ; zerowy rejestr od tego ful
        mulsd xmm0, qword ptr red_mult2  
        movzx eax, byte ptr[r8 + r10 + 1]
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr green_mult2
        addsd xmm0, xmm1
        movzx eax, byte ptr[r8 + r10] ; blue
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr blue_mult2
        addsd xmm0, xmm1
		cvttsd2si r12, xmm0
        cmp r12, 255
		jl green_ok
		mov r12, 255
green_ok:
		mov r14, r12
        

        movzx eax, byte ptr[r8 + r10+2] ; nie ma interpetowac tego co jest w srodku i ma je zastapic 0 
        cvtsi2sd xmm0, eax ; zerowy rejestr od tego ful
        mulsd xmm0, qword ptr red_mult3  
        movzx eax, byte ptr[r8 + r10 + 1]
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr green_mult3
        addsd xmm0, xmm1
        movzx eax, byte ptr[r8 + r10 ] ; blue
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr blue_mult3
        addsd xmm0, xmm1
		cvttsd2si r12, xmm0
        cmp r12, 255
		jl blue_ok
		mov r12, 255
      
blue_ok:
		mov r15, r12

        mov byte ptr[r8 + r10], r15b
		mov byte ptr[r8 + r10+2], r13b
		mov byte ptr[r8 + r10 + 1], r14b
		inc r10
        inc r10
        inc r10
        inc r10

b_w_end_loop:
    cmp r10, r9
    jl b_w_loop
    mov rbx, r11
    ret

MyProc2 ENDP
_TEXT ENDS
end