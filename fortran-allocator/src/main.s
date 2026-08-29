gimme_ram:
    mov rsi, rdi
    xor rdi, rdi
    mov rdx, 3
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    mov rax, 9
    syscall
    mov ebx,0
    syscall