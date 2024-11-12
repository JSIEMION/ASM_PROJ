.code
MyProc1 proc
mov rax, 1
mov rdi, 1
mov rsi, hello
mov rdx, hello_len
syscall
ret
MyProc1 endp
hello db "hello world", 10
hello_len = $ - hello
end