.code
_TEXT SEGMENT
checkMMXCapability PROC C
	push rbx			; Zapisz RBX
	pushfq				; Wypchnij flagi
	pop rax				; Pobierz je do RAX
	mov rbx, rax		; Zapisz do RBX na pozniej
	xor rax, 200000h	; Przelacz id flagi
	push rax			; Wypchnij przelaczone flagi
	popfq				; Pobierz je z powrotem do flag, zresetowa³y sie?
	pushfq				; Wypchnij flagi
	pop rax				; Pobierz je z powrotem do RAX
	cmp rax, rbx		; Porownaj aktualne flagi z wczesniej zapisanymi
	jz ThatsABity		; Jesli siê zresetowa³y, nie mozesz uzywaæ CPUID

	pop rbx				; Przywracam RBX
	mov eax, 1			; Nie zresetowa³o sie wiec...
	cpuid				; CPUID_0000_0001
	shr rdx, 23			; Shiftuj bit MMX do pozycji najbardziej po prawej
	and rdx, 1			; Wykonuje AND na rdx (jesli bylo 1, pozostanie 1)
	mov rax, rdx		; Przenosze RDX do akumulatora
	ret					; Zwracam 0/1

ThatsABity:
	pop rbx				; Procesor nie obsluguje CPUID lub MMX
	xor rax, rax		; Resetuj akumulator do 0
	ret
CheckMMXCapability ENDP
_TEXT ENDS
end