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

;	Program przekszta³ca obraz na filtr czarno bia³y
	

;///////////////////////////////////////////////////////////

.data
red_mult qword 0.11             ; wartosc czerwonego
green_mult qword 0.5870         ; wartosc zielonego
blue_mult qword 0.2989          ; wartosc niebieskiego

;///////////////////////////////////////////////////////////

.code
_TEXT SEGMENT

_DllMainCRTStartup PROC 

mov        RAX, 1 
ret

_DllMainCRTStartup ENDP
MyProc1 PROC
    mov r10, 0                              ; ustawienie licznika
    mov r11, rbx                            ; ustawienie zapisu 
    mov r9, rdx                             ; ustawienie dlugosci
    add r8, rcx                             ; ustawienie arraya i dodanie startu naszego w¹tku
    mov rbx, 4                              ; ustawienie ilosci channeli
    mov r12, 0                              ; ustawienie poczatkowego avg na 0
    jmp b_w_end_loop

b_w_loop:
		push r10                            ; pushujemy licznik
        movzx eax, byte ptr[r8 + r10]       ; przypisujemy wartosc licznika i startu
        cvtsi2sd xmm0, eax                  ; konwersja na zmiennoprzecinkowe 
        mulsd xmm0, qword ptr red_mult      ; mnozenie wartosci  i przypisanie do xmm0
        inc r10                             ; inkrementacja licznika

        movzx eax, byte ptr[r8 + r10]       ; powtórzenie dla zielonego
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr green_mult
        addsd xmm0, xmm1
        inc r10

        movzx eax, byte ptr[r8 + r10]       ; powtorzenie dla niebieskiego
        cvtsi2sd xmm1, eax
        mulsd xmm1, qword ptr blue_mult
        addsd xmm0, xmm1

        cvttsd2si r12, xmm0                 ; konwersja zmiennoprzecinkowych na int i przypisanie do r12
		pop r10                             

    mov byte ptr[r8 + r10], r12b            ; przypisanie najni¿szych 8 bitow 
    inc r10                                 ; inkrementacja licznika
    mov byte ptr[r8 + r10], r12b            ; przypisanie najni¿szych 8 bitow (teraz ju¿ licznik jest wiêkszy o 1)
    inc r10                                 ; inkrementacja licznika
    mov byte ptr[r8 + r10], r12b            ; przypisanie najni¿szych 8 bitow (teraz ju¿ licznik jest wiêkszy o 2)
    add r10, 2                              ; dodanie 2 do licznika

b_w_end_loop:
    cmp r10, r9                             ; porownanie licznika z d³ugoscia
    jl b_w_loop                             ; jeœli mniej skocz do b_w_loop
    mov rbx, r11                            ; jesli rowne to przepisz zapis do rbx zebysmy mogli zwrocic
    ret

MyProc1 ENDP
_TEXT ENDS
end