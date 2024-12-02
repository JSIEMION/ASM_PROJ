.data
chanels DW 3

.code
MyProc1 proc
			mov eax, 50
			movd xmm1, eax
			mov RAX, [RBP+40]
			mul R9
			mul chanels
			mov R10, RAX
			xor RAX, RAX

main_loop:	movdqu xmm0, [RCX+RAX]
			vpaddb xmm0, xmm0, xmm1
			
			add RAX, 16
			sub R10, 4
			jnz main_loop
			



			
ret
MyProc1 endp
end

