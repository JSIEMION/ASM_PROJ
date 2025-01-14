.data
chanels DB 3
mask_bright DW 9,9,9,9,9,9,0,0
test_values DW 0,0,255,0,0,255,0,0
odd_mask DB 255,255,255,0,0,0,0,0,0,0,0,0,0,0,0,0
even_mask DB 255,255,255,255,255,255,0,0,0,0,0,0,0,0,0,0



;RCX - adres tablicy Ÿród³owej
;R8 - wysokoœæ obrazu
;R9 - szerokoœæ obrazu
;R10 - adres tablicy docelowej
;R11 - liczba pixeli do przetworzenia
;R12 - index przetwarzanego pixela
;R13 - licznik pomijania piwrwszego i ostatniego pixela w wierszu
;R14 - padding
;[RSP+40] - numer pocz¹tkowego wiersza do przetworzenia
;[RSP+48] - numer wiersza po ostatnim wierszu do przetworzenia
;xmm0 - przetwarzane pixele (na œrodku maski)
;xmm1 - xmm8 - pozosta³e pixele w masce
;xmm9 - rejestr z tymczasowymi danymi
;xmm10 - rejestr z samymi 9 do mno¿enia z rejestrem xmm0
;xmm11 - maska dla niepa¿ystych rzêdów

.code
MyProc1 proc
	
			mov R10, RDX									;umieszczenie adresu tablicy docelowej w R10	!!!MUSI BYÆ PRZED PIERWSZ¥ INSTRUKCJ¥ DIV/MUL!!!
			movdqu xmm10, xmmword ptr[mask_bright]			;umieszczenie maski w xmm10


			mov RAX, R9
			mov RBX, 3
			mul RBX
			mov RBX, 4
			div RBX
			cmp RDX, 0
			je no_padding

padding_present:
			sub RBX, RDX
			mov R14, RBX

			jmp end_padding_setup

no_padding:
			mov R14, 0

end_padding_setup:
			xor RBX, RBX

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;ustawianie przesuniêcia w tablicy Ÿród³owej na odpowiednie miejsce w zale¿noœci od podzia³u obrazu na w¹tki

			mov RAX, [RSP+40]								;umieszczenie w RAX numeru pierwszego wiersza do przetworzenia
			sub RAX, 0
			jnz set_start									;if [RSP+40] == 0 pomiñ pierwszy wiersz
			add RAX, 1										;pominiêcie pierwszego wiersza

set_start:	mul R9											;mno¿enie pocz¹tkowej linii przez szerokoœæ obrazu wynik jest indeksem pierwszego pixela do przetworzenia
			
			mov RBX, 3										;mno¿enie przez iloœc kana³ów
			mul RBX									

			mov R12, RAX									;umieszczenie indeksu pocz¹tkowego pixela w R12 który przechowuje przesuniêcie w tablicach

			add R12, 3										;pominiêcie pierwszego pixela w wierszu

			mov RBX, R14
			mov RAX, [RSP+40]
			cmp RAX, 0
			jne no_first_row_correction
			add RAX, 1

no_first_row_correction:
			mul RBX
			add R12, RAX

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obliczanie iloœci pixeli do przetworzenia w zale¿noœci od iloœci w¹tków
			
			mov RAX, [RSP+48]								;umieszczenie w RAX numeru ostatniego wiersza do przetworzenia
			sub RAX, R8										;porównanie z wysokoœci¹ obrazu
			
			jne not_last									;if R8 == [RSP+48] odejmij ostatni wiersz
			mov R11, [RSP+48]								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, [RSP+40]								;odjêcie pocz¹tkowego wiersza wynikiem jest iloœæ wierszy do przetworzenia
			sub R11, 1										;pominiêcie ostatniego wiersza
			jmp check_first									;skok do dalszych obliczeñ
			

not_last:	mov R11, [RSP+48]								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, [RSP+40]								;odjêcie pocz¹tkowego wiersza, wynikiem jest iloœæ wierszy do przetworzenia
			
check_first:
			mov RAX, [RSP+40]								;przeniesienie numeru pierwszego wiersza do RAX
			sub RAX, 0										
			jnz multiply_pixels								;if [RSP+40] == 0 zmniejsz iloœæ iteracji o 1 wiersz
			sub R11, 1										;odejmowanie jednego wiersza

multiply_pixels:
			mov RAX, R11									;przeniesienie wartoœci do RAX w celu mno¿enia
			mul R9											;mno¿enie koñcowej linii przez szerokoœæ obrazu wynik jest liczb¹ pixeli do przetworzenia
			mov R11, RAX									;umieszczenie wyniku w R11
			sub R11, 1										;odjêcie pierwszego pixela pomijanego przy inicjalizacji r12

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;inicjalizacja licznika pominiêæ

			mov R13, R9										;
			sub R13, 2										;inicjalizacja licznika pominiêæ pierwszego i ostatniego pixela


;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;g³ówna pêtla programu


main_loop:	xor RAX, RAX									;wyczyszczenie RAX
			
			

			movdqu xmm9, [RCX+R12]							;przeniesienie 8 bitowych danych z tablicy Ÿród³owej do xmm1
			pmovzxbw xmm0, xmm9								;przeniesienie dolnych 8 danych z xmm1 do xmm0 z rozszerzeniem ich do 16 bitów


			mov RAX, R12
			sub RAX, R9
			sub RAX, R9
			sub RAX, R9
			sub RAX, R14
			sub RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm1, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm2, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm3, xmm9


			mov RAX, R12
			sub RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm4, xmm9

			add RAX, 6
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm5, xmm9


			mov RAX, R12
			add RAX, R9
			add RAX, R9
			add RAX, R9
			add RAX, R14
			sub RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm6, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm7, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm8, xmm9

			
			pmullw xmm0, xmm10

			psubusw xmm0, xmm1
			psubusw xmm0, xmm2
			psubusw xmm0, xmm3
			psubusw xmm0, xmm4
			psubusw xmm0, xmm5
			psubusw xmm0, xmm6
			psubusw xmm0, xmm7
			psubusw xmm0, xmm8

			cmp R13, 1
			je last_pixel_in_odd_width

			packuswb xmm0, xmm0								;skompresowanie danych spowrotem do 8 bitów z nasyceniem bez znaku
			lea RAX, [even_mask]
			movdqu xmm11, [RAX]
			pand xmm0, xmm11
			movdqu [R10+R12], xmm0
			sub R13, 2
			add R12, 6
			sub R11, 2
			jmp continue_after_odd_width_check

last_pixel_in_odd_width:
			
			packuswb xmm0, xmm0
			lea RAX, [odd_mask]
			movdqu xmm11, [RAX]
			pand xmm0, xmm11
			movdqu [R10+R12], xmm0
			sub R13, 1
			add R12, 3
			sub R11, 1

continue_after_odd_width_check:
			;movdqu [R10+R12], xmm0							;przeniesienie danych z xmm0 do tablicy docelowej
			
													;dodanie 6 (iloœci pe³nych pixeli w xmm * iloœæ kana³ów) do przesuniêcia w tablicy w R12
			cmp R13, 0
			je skipping

continue_after_skip:			
			;sub R11, 2										;odjêcie 2 (iloœci pe³nych pixeli w xmm) od ca³kowitej iloœci pixeli
			;cmp R11, 0
			;je end_program
			jmp main_loop									;if RAX(R11) > 0 kontunuuj pêtlê

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obs³uga pominiêæ

skipping:			
			mov R13, R9
			sub R13, 2
			add R12, 6
			add R12, R14
			sub R11, 2
			js end_program
			jmp continue_after_skip


end_program:			
		ret
		MyProc1 endp
		end

