.data
    newline: .asciiz "\n"
    msg_soma: .asciiz "Soma: "
    msg_sub: .asciiz "Subtração: "

.text
.globl main
main:
    # Colocando os valores nas variáveis t0 e t1
    li $t0, 10
    li $t1, 20
    # Realizando as instruções de soma, subtração
    add $s0, $t0, $t1
    sub $s1, $t0, $t1
    and $s2, $t0, $t1
    # Imprimindo uma mensagem de soma
    li $v0, 4
    la $a0, msg_soma
    syscall 
    # Imprimindo o valor resultante da soma
    li $v0, 1
    move $a0, $s0
    syscall
    # Imprimindo uma quebra de linha
    li $v0, 4
    la $a0, newline
    syscall
    # Imprimindo uma mensagem de subtração
    li $v0, 4
    la $a0, msg_sub
    syscall
    # Imprimindo o valor resultante da subtração
    li $v0, 1
    move $a0, $s1
    syscall


    # Finalizando o programa
    li $v0, 10
    syscall
