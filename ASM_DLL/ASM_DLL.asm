.data
chanels DB 3
mask_bright DW 9,9,9,9,9,9,9,9
test_values DW 0,0,255,0,0,255,0,0
overrite_protection_mask_general DB 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0




;RCX - adres tablicy �r�d�owej
;R8 - wysoko�� obrazu
;R9 - szeroko�� obrazu
;R10 - adres tablicy docelowej
;R11 - liczba bajt�w do przetworzenia
;R12 - index przetwarzanego bajtu
;R13 - licznik pomijania piwrwszego i ostatniego pixela w wierszu (w bajtach)
;R14 - padding
;R15 - stride
;[RSP+40] -> RSI - numer pocz�tkowego wiersza do przetworzenia (dost�pny tylko do ko�ca inicjaizacji)
;[RSP+48] ->RSI - numer wiersza po ostatnim wierszu do przetworzenia (dost�pny tylko do ko�ca inicjalizacji)
;xmm0 - przetwarzane pixele (na �rodku maski)
;xmm1 - xmm8 - pozosta�e pixele w masce
;xmm10 - rejestr z samymi 9 do mno�enia z rejestrem xmm0
;xmm11 - maska koryguj�ca

.code
asmProc proc
			mov R10d, [RSP+40]
			mov R11d, [RSP+48]
			push RBX
			push RBP
			push RDI
			push RSI
			push R12
			push R13
			push R14 
			push R15
			mov RSI, R10
			mov RDI, R11
	
			mov R10, RDX									;umieszczenie adresu tablicy docelowej w R10	!!!MUSI BY� PRZED PIERWSZ� INSTRUKCJ� DIV/MUL!!!
			movdqu xmm10, xmmword ptr[mask_bright]			;umieszczenie maski w xmm10


			mov RAX, R9										;umieszczanie szeroko�ci w RAX
			mov RBX, 3										;umieszczanie liczby 3 (ilo�� bajt�w na pixel) w RBX do mno�enia w przysz�o�ci
			mul RBX											;mno�enie bajt�w na pixel przez szeroko��
			mov RBX, 4										;umieszczanie 4 (zaokr�glanie bajt�w w rz�dzie w formacie BMP) w RBX
			div RBX											;dzielenie szeroko�ci w bajtach przez 4
			cmp RDX, 0										;sprawdzanie czy szeroko�� w bajtach by�a podzielna 4 bez reszty
			je no_padding									;if R9*3 % 4 == 0 brak paddingu

padding_present:
			sub RBX, RDX									;obliczanie paddingu (4-(R9*3)%4)
			mov R14, RBX									;przenoszenie paddingu do R14

			jmp end_padding_setup

no_padding:
			mov R14, 0										;brak paddingu

end_padding_setup:
			xor RBX, RBX

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;ustawianie przesuni�cia w tablicy �r�d�owej na odpowiednie miejsce w zale�no�ci od podzia�u obrazu na w�tki

			mov RAX, RSI								;umieszczenie w RAX numeru pierwszego wiersza do przetworzenia
			sub RAX, 0
			jnz set_start									;if [RSP+40] == 0 pomi� pierwszy wiersz
			add RAX, 1										;pomini�cie pierwszego wiersza

set_start:	mul R9											;mno�enie pocz�tkowej linii przez szeroko�� obrazu wynik jest indeksem pierwszego pixela do przetworzenia
			
			mov RBX, 3										;mno�enie przez ilo�c kana��w
			mul RBX									

			mov R12, RAX									;umieszczenie indeksu pocz�tkowego pixela w R12 kt�ry przechowuje przesuni�cie w tablicach

			add R12, 3										;pomini�cie pierwszego pixela w wierszu

			mov RBX, R14									;przenoszenie paddingu do RBX
			mov RAX, RSI								;przenoszenie numeru pocz�tkowego wiersza do RAX
			cmp RAX, 0										;por�wnanie numeru pierwszego wiersza do przerobienia z zerem
			jne no_first_row_correction						;if [RSP+40] == 0 pomini�cie pierwszego wiersza
			add RAX, 1										;pomini�cie pierwszego wiersza

no_first_row_correction:
			mul RBX											;mno�enie paddnigu przez numer pierwszego wiersza
			add R12, RAX									;dodanie obliczonej warto�ci do przesuni�cia wzgl�dem pocz�tku danych

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obliczanie ilo�ci bajt�w do przetworzenia w zale�no�ci od ilo�ci w�tk�w
			
			mov RAX, RDI								;umieszczenie w RAX numeru ostatniego wiersza do przetworzenia
			sub RAX, R8										;por�wnanie z wysoko�ci� obrazu
			
			jne not_last									;if R8 == [RSP+48] odejmij ostatni wiersz
			mov R11, RDI								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, RSI								;odj�cie pocz�tkowego wiersza wynikiem jest ilo�� wierszy do przetworzenia
			sub R11, 1										;pomini�cie ostatniego wiersza
			jmp check_first									;skok do dalszych oblicze�
			

not_last:	mov R11, RDI								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, RSI								;odj�cie pocz�tkowego wiersza, wynikiem jest ilo�� wierszy do przetworzenia
			
check_first:
			mov RAX, RSI								;przeniesienie numeru pierwszego wiersza do RAX
			sub RAX, 0										
			jnz multiply_pixels								;if [RSP+40] == 0 zmniejsz ilo�� iteracji o 1 wiersz
			sub R11, 1										;odejmowanie jednego wiersza

multiply_pixels:
			mov RAX, R11									;przeniesienie warto�ci do RAX w celu mno�enia
			mul R9											;mno�enie ko�cowej linii przez szeroko�� obrazu wynik jest liczb� pixeli do przetworzenia
			mov RBX, 3
			mul RBX
			mov RBX, RAX
			mov RAX, R14
			mul R11
			mov R11, RBX									;umieszczenie wyniku w R11
			add R11, RAX
			sub R11, 3										;odj�cie pierwszego pixela pomijanego przy inicjalizacji r12

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;inicjalizacja licznika pomini��

			mov RAX, R9										;
			mov RBX, 3										;
			mul RBX											;
			sub RAX, 6										;
			mov R13, RAX									;
															;inicjalizacja licznika pomini�� pierwszego i ostatniego pixela


;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;obliczanie stride
			
			
			mov RAX, 3
			mul R9
			add RAX, R14
			mov R15, RAX
			xor RAX, RAX
			xor RBX, RBX

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;g��wna p�tla programu


main_loop:	xor RAX, RAX									;wyczyszczenie RAX
			
			
			pmovzxbw xmm0, [RCX+R12]						;przeniesienie dolnych 8 danych z xmm1 do xmm0 z rozszerzeniem ich do 16 bit�w


			mov RAX, R12
			sub RAX, R15
			pmovzxbw xmm1, [RCX+RAX-3]

			pmovzxbw xmm2, [RCX+RAX]

			pmovzxbw xmm3, [RCX+RAX+3]


			mov RAX, R12
			pmovzxbw xmm4, [RCX+RAX-3]

			pmovzxbw xmm5, [RCX+RAX+3]


			mov RAX, R12
			add RAX, R15
			pmovzxbw xmm6, [RCX+RAX-3]

			pmovzxbw xmm7, [RCX+RAX]

			pmovzxbw xmm8, [RCX+RAX+3]

			
			pmullw xmm0, xmm10

			paddusw xmm1, xmm2
			paddusw xmm3, xmm4
			paddusw xmm5, xmm6
			paddusw xmm7, xmm8

			paddusw xmm1, xmm3
			paddusw xmm5, xmm7

			psubusw xmm0, xmm1

			psubusw xmm0, xmm5


			cmp R13, 16
			js overrite_protection

			packuswb xmm0, xmm0
			movdqu [R10+R12], xmm0

			
			add R12, 8
			sub R11, 8
			sub R13, 8
			jmp main_loop

overrite_protection:


			cmp R13, 8
			js last_in_row


			packuswb xmm0, xmm0

			mov RDI, R10
			add RDI, R12
			lea RAX, [overrite_protection_mask_general]
			movdqu xmm11, [RAX]
			maskmovdqu xmm0, xmm11



			add R12, 8
			sub R11, 8
			sub R13, 8
			
			cmp R13, 0
			je skipping

			jmp main_loop

last_in_row:
			packuswb xmm0, xmm0


			lea RAX, [overrite_protection_mask_general]
			movdqu xmm11, [RAX]

			mov RAX, 8
			sub RAX, R13

			cmp RAX, 1
			je shift_1

			cmp RAX, 2
			je shift_2

			cmp RAX, 3
			je shift_3

			cmp RAX, 4
			je shift_4

			cmp RAX, 5
			je shift_5

			cmp RAX, 6
			je shift_6

			cmp RAX, 7
			je shift_7



continue_after_shift:

			mov RDI, R10
			add RDI, R12

			maskmovdqu xmm0, xmm11



			add R12, R13
			sub R11, R13
			sub R13, R13

			jmp skipping

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obs�uga pomini��

skipping:	
			mov RAX, R9										
			mov RBX, 3										
			mul RBX											
			sub RAX, 6										
			mov R13, RAX

			add R12, 6
			add R12, R14
			sub R11, 6
			sub R11, R14
			js end_program
			jmp main_loop

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obs�uga przesuni�cia bitowego

shift_1:
			psrldq xmm11, 1
			jmp continue_after_shift
shift_2:
			psrldq xmm11, 2
			jmp continue_after_shift
shift_3:
			psrldq xmm11, 3
			jmp continue_after_shift
shift_4:
			psrldq xmm11, 4
			jmp continue_after_shift
shift_5:
			psrldq xmm11, 5
			jmp continue_after_shift
shift_6:
			psrldq xmm11, 6
			jmp continue_after_shift
shift_7:
			psrldq xmm11, 7
			jmp continue_after_shift


end_program:


			pop R15
			pop R14
			pop R13
			pop R12
			pop RSI
			pop RDI
			pop RBP
			pop RBX

		ret
		asmProc endp
		end

