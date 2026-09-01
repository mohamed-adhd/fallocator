.intel_syntax noprefix

.global asm_gimme_ram
.type asm_gimme_ram, @function

asm_gimme_ram:
    mov rsi, rdi
    xor rdi, rdi
    mov edx, 3
    mov r10d, 0x22
    mov r8, -1
    xor r9d, r9d
    mov eax, 9
    syscall
    ret