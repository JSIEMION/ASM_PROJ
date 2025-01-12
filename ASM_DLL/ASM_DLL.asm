.data
chanels DB 3
mask_bright DW 90,90,90,90,90,90,0,0
test_values DW 0,0,255,0,0,255,0,0


;RCX - adres tablicy �r�d�owej
;R8 - wysoko�� obrazu
;R9 - szeroko�� obrazu
;R10 - adres tablicy docelowej
;R11 - liczba pixeli do przetworzenia
;R12 - index przetwarzanego pixela
;R13 - licznik pomijania piwrwszego i ostatniego pixela w wierszu
;[RSP+40] - numer pocz�tkowego wiersza do przetworzenia
;[RSP+48] - numer wiersza po ostatnim wierszu do przetworzenia
;xmm0 - przetwarzane pixele (na �rodku maski)
;xmm1 - xmm8 - pozosta�e pixele w masce
;xmm9 - rejestr z tymczasowymi danymi
;xmm10 - rejestr z samymi 9 do mno�enia z rejestrem xmm0

.code
MyProc1 proc
;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;ustawianie przesuni�cia w tablicy �r�d�owej na odpowiednie miejsce w zale�no�ci od podzia�u obrazu na w�tki


			mov R10, RDX									;umieszczenie adresu tablicy docelowej w R10
			movdqu xmm10, xmmword ptr[mask_bright]			;umieszczenie maski w xmm10

			mov RAX, [RSP+40]								;umieszczenie w RAX numeru pierwszego wiersza do przetworzenia
			sub RAX, 0
			jnz set_start									;if [RSP+40] == 0 pomi� pierwszy wiersz
			add RAX, 1										;pomini�cie pierwszego wiersza

set_start:	mul R9											;mno�enie pocz�tkowej linii przez szeroko�� obrazu wynik jest indeksem pierwszego pixela do przetworzenia
			
			mov RBX, 3										;mno�enie przez ilo�c kana��w
			mul RBX									
			
			mov R12, RAX									;umieszczenie indeksu pocz�tkowego pixela w R12 kt�ry przechowuje przesuni�cie w tablicach

			add R12, 3										;pomini�cie pierwszego pixela w wierszu

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obliczanie ilo�ci pixeli do przetworzenia w zale�no�ci od ilo�ci w�tk�w
			
			mov RAX, [RSP+48]								;umieszczenie w RAX numeru ostatniego wiersza do przetworzenia
			sub RAX, R8										;por�wnanie z wysoko�ci� obrazu
			
			jne not_last									;if R8 == [RSP+48] odejmij ostatni wiersz
			mov R11, [RSP+48]								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, [RSP+40]								;odj�cie pocz�tkowego wiersza wynikiem jest ilo�� wierszy do przetworzenia
			sub R11, 1										;pomini�cie ostatniego wiersza
			jmp check_first									;skok do dalszych oblicze�
			

not_last:	mov R11, [RSP+48]								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, [RSP+40]								;odj�cie pocz�tkowego wiersza, wynikiem jest ilo�� wierszy do przetworzenia
			
check_first:
			mov RAX, [RSP+40]								;przeniesienie numeru pierwszego wiersza do RAX
			sub RAX, 0										
			jnz multiply_pixels								;if [RSP+40] == 0 zmniejsz ilo�� iteracji o 1 wiersz
			sub R11, 1										;odejmowanie jednego wiersza

multiply_pixels:
			mov RAX, R11									;przeniesienie warto�ci do RAX w celu mno�enia
			mul R9											;mno�enie ko�cowej linii przez szeroko�� obrazu wynik jest liczb� pixeli do przetworzenia
			mov R11, RAX									;umieszczenie wyniku w R11

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;inicjalizacja licznika pomini��

			mov R13, R9										;
			sub R13, 2										;inicjalizacja licznika pomini�� pierwszego i ostatniego pixela

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;g��wna p�tla programu


main_loop:	xor RAX, RAX									;wyczyszczenie RAX
			
			

			movdqu xmm9, [RCX+R12]							;przeniesienie 8 bitowych danych z tablicy �r�d�owej do xmm1
			pmovzxbw xmm0, xmm9								;przeniesienie dolnych 8 danych z xmm1 do xmm0 z rozszerzeniem ich do 16 bit�w

			;moddqu xmm9, [RCX+R12]
			pmovzxbw xmm11, xmm9

			mov RAX, R12
			sub RAX, R9
			sub RAX, R9
			sub RAX, R9
			sub RAX, 3
			;sub RAX, 1
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
			sub RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm6, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm7, xmm9

			add RAX, 3
			movdqu xmm9, [RCX+RAX]
			pmovzxbw xmm8, xmm9

			
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11
			paddusw xmm0, xmm11

			psubusw xmm0, xmm1
			psubusw xmm0, xmm2
			psubusw xmm0, xmm3
			psubusw xmm0, xmm4
			psubusw xmm0, xmm5
			psubusw xmm0, xmm6
			psubusw xmm0, xmm7
			psubusw xmm0, xmm8

			;paddusb xmm0, xmm10								;dodanie do danych w xmm0 warto�ci z maski

			packuswb xmm0, xmm0								;skompresowanie danych spowrotem do 8 bit�w z nasyceniem bez znaku



			movdqu [R10+R12], xmm0							;przeniesienie danych z xmm0 do tablicy docelowej
			
			add R12, 6										;dodanie 6 (ilo�ci pe�nych pixeli w xmm * ilo�� kana��w) do przesuni�cia w tablicy w R12
			sub R13, 2										
			jz skipping

continue_after_skip:			
			sub R11, 2										;odj�cie 2 (ilo�ci pe�nych pixeli w xmm) od sa�kowitej ilo�ci pixeli

			jnz main_loop									;if RAX(R11) > 0 kontunuuj p�tl�
			jmp end_program
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obs�uga pomini��

skipping:			
			mov R13, R9
			sub R13, 2
			add R12, 6
			sub R11, 2
			jz end_program
			jmp continue_after_skip


end_program:			
		ret
		MyProc1 endp
		end

