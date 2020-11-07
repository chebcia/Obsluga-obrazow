;///////////////////////////////////////////////////////////
;/*
;* Autor: Natalia Cheba
;*
;* Informatyka
;* Semestr: 5
;* Grupa dziekañska: 3
;* Sekcja: 2
;* Temat: Konwerter obrazu
;*/
;///////////////////////////////////////////////////////////

;	Program przekszta³ca obraz na filtr sepie
	
;///////////////////////////////////////////////////////////

;	Ustawienie odpowiednich wartosci

;/////////////////////////////////////////////////////////// 
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
    mov r10, 0                                   ; ustawienie licznika
    mov r11, rbx                                 ; ustawienie zapisu 
    mov r9, rdx                                  ; ustawienie dlugosci
    add r8, rcx                                  ; ustawienie arraya i dodanie startu naszego w¹tku
    mov rbx, 4                                   ; ustawienie ilosci channeli
    jmp b_w_end_loop                             ; skok do petli

b_w_loop:
        movzx eax, byte ptr[r8 + r10+2]          ; przypisujemy wartosc licznika i startu + 2, poniewa¿ jest to wartoœæ dla red BGR - czerwony
        cvtsi2sd xmm0, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm0, qword ptr red_mult1          ; mnozenie i zapis do xmm0
        movzx eax, byte ptr[r8 + r10 + 1]        ; przypisujemy wartosc licznika i startu + 1, poniewa¿ jest to wartoœæ dla red BGR - zielony
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr green_mult1        ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie do xmm0
        movzx eax, byte ptr[r8 + r10]            ; przypisujemy wartosc licznika i startu + 0, poniewa¿ jest to wartoœæ dla red BGR - niebieski
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr blue_mult1         ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie do xmm0
       
        cvttsd2si r12, xmm0                      ; przypisanie wartosci do r12 
        cmp r12, 255                             ; porownanie wartosci z 255 w celu pozniejszej zamiany na 255
		jl red_ok                                ; jesli mniej skacz do red_ok
		mov r12, 255                             ; przypisanie najwiekszej wartosci do r12
red_ok:
		mov r13, r12                             ; przypisanie r12 do r13
        movzx eax, byte ptr[r8 + r10+2]          ; przypisujemy wartosc licznika i startu + 2, poniewa¿ jest to wartoœæ dla red BGR - czerwony
        cvtsi2sd xmm0, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm0, qword ptr red_mult2          ; mnozenie i zapis do xmm0
        movzx eax, byte ptr[r8 + r10 + 1]        ; przypisujemy wartosc licznika i startu + 1, poniewa¿ jest to wartoœæ dla red BGR - zielony
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr green_mult2        ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie xmm1 do xmm0 i zapis do xmm0
        movzx eax, byte ptr[r8 + r10] ; blue     ; przypisujemy wartosc licznika i startu + 0, poniewa¿ jest to wartoœæ dla red BGR - niebieski
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr blue_mult2         ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie xmm1 do xmm0 i zapis do xmm0
		cvttsd2si r12, xmm0                      ; przypisanie wartosci do r12  
        cmp r12, 255                             ; porownanie wartosci z 255 w celu pozniejszej zamiany na 255
		jl green_ok                              ; jesli mniej skacz do green_ok
		mov r12, 255                             ; przypisanie najwiekszej wartosci do r12
green_ok:
		mov r14, r12                             ; przypisanie r12 do r14
        movzx eax, byte ptr[r8 + r10+2]          ; przypisujemy wartosc licznika i startu + 2, poniewa¿ jest to wartoœæ dla red BGR - czerwony
        cvtsi2sd xmm0, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm0, qword ptr red_mult3          ; mnozenie i zapis do xmm0
        movzx eax, byte ptr[r8 + r10 + 1]        ; przypisujemy wartosc licznika i startu + 1, poniewa¿ jest to wartoœæ dla red BGR - zielony
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr green_mult3        ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie xmm1 do xmm0 i zapis do xmm0
        movzx eax, byte ptr[r8 + r10 ]           ; przypisujemy wartosc licznika i startu + 0, poniewa¿ jest to wartoœæ dla red BGR - niebieski
        cvtsi2sd xmm1, eax                       ; konwersja na zmiennoprzecinkowe
        mulsd xmm1, qword ptr blue_mult3         ; mnozenie i zapis do xmm1
        addsd xmm0, xmm1                         ; dodanie xmm1 do xmm0 i zapis do xmm0
		cvttsd2si r12, xmm0                      ; przypisanie wartosci do r12 
        cmp r12, 255                             ; porownanie wartosci z 255 w celu pozniejszej zamiany na 255
		jl blue_ok                               ; jesli mniej skacz do blue_ok
		mov r12, 255                             ; przypisanie najwiekszej wartosci do r12
       
blue_ok:
		mov r15, r12                             ; przypisanie r12 do r15
        mov byte ptr[r8 + r10], r15b             ; przypisanie najni¿szych 8 bitow z niebieskiego
		mov byte ptr[r8 + r10+2], r13b           ; przypisanie najni¿szych 8 bitow z czerwonego  
		mov byte ptr[r8 + r10 + 1], r14b         ; przypisanie najni¿szych 8 bitow z zielonego
		inc r10                                  ; przeskakujemy o 4 bity
        inc r10
        inc r10
        inc r10

b_w_end_loop:
    cmp r10, r9                                  ; porownanie licznika z d³ugoscia
    jl b_w_loop                                  ; jeœli mniej skocz do b_w_loop
    mov rbx, r11                                 ; jesli rowne to przepisz zapis do rbx zebysmy mogli zwrocic
    ret

MyProc2 ENDP
_TEXT ENDS
end