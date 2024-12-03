.686
.model flat

extern _ExitProcess@4 : proc
extern _MessageBoxA@16 : proc
extern _fopen : proc
extern _fread : proc
extern _fclose : proc

public _read2msg

.data
status db "r", 0
filename db 12 dup (?), 0
otwarty_plik dd " ", 0
output db 1024 dup (?), 0


.code

_read2msg proc
	push ebp
	mov ebp, esp
	;sub esp, 32 ; rezerwacja zmiennej lokalnej ; bo robimy 16+8 bajtow czyli 96?? to zrobmy 128
	push esi
	push edi
	push ebx
	;prolog zrobiony :))

	mov esi, [ebp+8]

	mov ecx, 0

odczyt_nazwy:
	mov al, byte ptr [esi + ecx]
	cmp al ,'0'
	je koniec

	mov filename[ecx], al
	inc ecx
	cmp ecx, 12
	jne odczyt_nazwy


koniec:

	; FILE * fopen ( const char * filename, const char * mode );
	push offset status ;tytaj ten mode
	push offset filename; tutaj nazwa pliku
	call _fopen
	add esp, 8


	mov otwarty_plik, eax ; przeniesienie wskaznika do otwartego pliku

	;size_t fread ( void * ptr, size_t size, size_t count, FILE * stream );
	mov eax, otwarty_plik
	push eax ; stream
	push 100
	push 1
	push offset output
	call _fread
	add esp, 16


	;int fclose(FILE *stream);
	mov eax, otwarty_plik
	push eax ;tytaj ten mode
	call _fclose
	add esp, 4


	push 0   ; utype
	push offset output
	push OFFSET output
	push 0 ; hwnd
	call _MessageBoxA@16


	;prolog odczarowac
	pop ebx
	pop edi
	pop esi
	;add esp, 24
	pop ebp
	RET
_read2msg endp


END
