.data
    string: .asciiz "Welcome to Bank Management System"

.text

.globl main
.ent main

main:
    li $v0, 4
    la $a0, string
    syscall

    li $v0, 10
    syscall

jr $ra
.end main