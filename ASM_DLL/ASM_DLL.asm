.data
chanels DB 3
mask_bright DB 80,80,80,80,80,80,80,80,80,80,80,80,80,80,80,0

.code
MyProc1 proc
			sub R9, 1
			mov R11, RDX
			movdqu xmm1, xmmword ptr[mask_bright]
			mov RAX, [RBP+40]
			mul R9
			mov R10, RAX
			xor RAX, RAX
			mov R12, 0

main_loop:	
			movdqu xmm0, [RCX+R12]
			paddusb xmm0, xmm1
			movdqu [R11+R12], xmm0
			add R12, 15
			sub R10, 5
			mov RAX, R12
			jnz main_loop
			



			
ret
MyProc1 endp
end

