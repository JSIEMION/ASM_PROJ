.data
chanels DB 3
mask_bright DW 9,9,9,9,9,9,9,9
test_values DW 0,0,255,0,0,255,0,0
overrite_protection_mask_general DB 255, 255, 255, 255, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0




;RCX - adres tablicy Ÿród³owej
;R8 - wysokoœæ obrazu
;R9 - szerokoœæ obrazu
;R10 - adres tablicy docelowej
;R11 - liczba bajtów do przetworzenia
;R12 - index przetwarzanego bajtu
;R13 - licznik pomijania piwrwszego i ostatniego pixela w wierszu (w bajtach)
;R14 - padding
;R15 - stride
;[RSP+40] -> RSI - numer pocz¹tkowego wiersza do przetworzenia (dostêpny tylko do koñca inicjaizacji)
;[RSP+48] ->RSI - numer wiersza po ostatnim wierszu do przetworzenia (dostêpny tylko do koñca inicjalizacji)
;xmm0 - przetwarzane pixele (na œrodku maski)
;xmm1 - xmm8 - pozosta³e pixele w masce
;xmm10 - rejestr z samymi 9 do mno¿enia z rejestrem xmm0
;xmm11 - maska koryguj¹ca

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
	
			mov R10, RDX									;umieszczenie adresu tablicy docelowej w R10	!!!MUSI BYÆ PRZED PIERWSZ¥ INSTRUKCJ¥ DIV/MUL!!!
			movdqu xmm10, xmmword ptr[mask_bright]			;umieszczenie maski w xmm10


			mov RAX, R9										;umieszczanie szerokoœci w RAX
			mov RBX, 3										;umieszczanie liczby 3 (iloœæ bajtów na pixel) w RBX do mno¿enia w przysz³oœci
			mul RBX											;mno¿enie bajtów na pixel przez szerokoœæ
			mov RBX, 4										;umieszczanie 4 (zaokr¹glanie bajtów w rzêdzie w formacie BMP) w RBX
			div RBX											;dzielenie szerokoœci w bajtach przez 4
			cmp RDX, 0										;sprawdzanie czy szerokoœæ w bajtach by³a podzielna 4 bez reszty
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
;ustawianie przesuniêcia w tablicy Ÿród³owej na odpowiednie miejsce w zale¿noœci od podzia³u obrazu na w¹tki

			mov RAX, RSI								;umieszczenie w RAX numeru pierwszego wiersza do przetworzenia
			sub RAX, 0
			jnz set_start									;if [RSP+40] == 0 pomiñ pierwszy wiersz
			add RAX, 1										;pominiêcie pierwszego wiersza

set_start:	mul R9											;mno¿enie pocz¹tkowej linii przez szerokoœæ obrazu wynik jest indeksem pierwszego pixela do przetworzenia
			
			mov RBX, 3										;mno¿enie przez iloœc kana³ów
			mul RBX									

			mov R12, RAX									;umieszczenie indeksu pocz¹tkowego pixela w R12 który przechowuje przesuniêcie w tablicach

			add R12, 3										;pominiêcie pierwszego pixela w wierszu

			mov RBX, R14									;przenoszenie paddingu do RBX
			mov RAX, RSI								;przenoszenie numeru pocz¹tkowego wiersza do RAX
			cmp RAX, 0										;porównanie numeru pierwszego wiersza do przerobienia z zerem
			jne no_first_row_correction						;if [RSP+40] == 0 pominiêcie pierwszego wiersza
			add RAX, 1										;pominiêcie pierwszego wiersza

no_first_row_correction:
			mul RBX											;mno¿enie paddnigu przez numer pierwszego wiersza
			add R12, RAX									;dodanie obliczonej wartoœci do przesuniêcia wzglêdem pocz¹tku danych

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;obliczanie iloœci bajtów do przetworzenia w zale¿noœci od iloœci w¹tków
			
			mov RAX, RDI								;umieszczenie w RAX numeru ostatniego wiersza do przetworzenia
			sub RAX, R8										;porównanie z wysokoœci¹ obrazu
			
			jne not_last									;if R8 == [RSP+48] odejmij ostatni wiersz
			mov R11, RDI								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, RSI								;odjêcie pocz¹tkowego wiersza wynikiem jest iloœæ wierszy do przetworzenia
			sub R11, 1										;pominiêcie ostatniego wiersza
			jmp check_first									;skok do dalszych obliczeñ
			

not_last:	mov R11, RDI								;umieszczenie w R11 numeru ostatniego wiersza do przetworzenia
			sub R11, RSI								;odjêcie pocz¹tkowego wiersza, wynikiem jest iloœæ wierszy do przetworzenia
			
check_first:
			mov RAX, RSI								;przeniesienie numeru pierwszego wiersza do RAX
			sub RAX, 0										
			jnz multiply_pixels								;if [RSP+40] == 0 zmniejsz iloœæ iteracji o 1 wiersz
			sub R11, 1										;odejmowanie jednego wiersza

multiply_pixels:
			mov RAX, R11									;przeniesienie wartoœci do RAX w celu mno¿enia
			mul R9											;mno¿enie koñcowej linii przez szerokoœæ obrazu wynik jest liczb¹ pixeli do przetworzenia
			mov RBX, 3
			mul RBX
			mov RBX, RAX
			mov RAX, R14
			mul R11
			mov R11, RBX									;umieszczenie wyniku w R11
			add R11, RAX
			sub R11, 3										;odjêcie pierwszego pixela pomijanego przy inicjalizacji r12

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;inicjalizacja licznika pominiêæ

			mov RAX, R9										;
			mov RBX, 3										;
			mul RBX											;
			sub RAX, 6										;
			mov R13, RAX									;
															;inicjalizacja licznika pominiêæ pierwszego i ostatniego pixela


;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;obliczanie stride
			
			
			mov RAX, 3
			mul R9
			add RAX, R14
			mov R15, RAX
			xor RAX, RAX
			xor RBX, RBX

;-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
;g³ówna pêtla programu


main_loop:	xor RAX, RAX									;wyczyszczenie RAX
			
			
			pmovzxbw xmm0, [RCX+R12]						;przeniesienie dolnych 8 danych z xmm1 do xmm0 z rozszerzeniem ich do 16 bitów


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
;obs³uga pominiêæ

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
;obs³uga przesuniêcia bitowego

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

