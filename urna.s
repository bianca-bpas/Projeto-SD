.data
newline: .asciiz "\n"
ENCERRAR: .word 12345

# Strings dos candidatos
candidato1: .asciiz "C1\n"
candidato2: .asciiz "C2\n"
candidato3: .asciiz "C3\n"
nulo: .asciiz "Nulo\n"

# Array de endereços dos nomes dos candidatos
candidatos: .word candidato1, candidato2, candidato3, nulo

votos: .word 0, 0, 0, 0, 0 # C1, C2, C3, Nulo, Branco

msg_digite_voto: .asciiz "Digite seu voto (0-3) ou 4 para branco: \n"
msg_confirmar: .asciiz "Aperte confirmar (C): \n"
confirma: .byte 'C'
msg_resultado: .asciiz "\nResultado da votação:\n"

.text
.globl main
main:
    li $t1, -1

loop: 
    li $v0, 4
    la $a0, msg_digite_voto
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    lw $t0, ENCERRAR
    beq $t0, $t1, end_loop

    blt $t1, 0, loop
    bgt $t1, 4, loop

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 4
    la $a0, msg_confirmar
    syscall

    li $v0, 12
    syscall
    li $t2, 'C'
    bne $v0, $t2, loop

    sll $t2, $t1, 2
    la $t3, votos
    add $t3, $t3, $t2
    lw $t4, 0($t3)
    addi $t4, $t4, 1
    sw $t4, 0($t3)

    j loop

end_loop:
    li $v0, 4
    la $a0, msg_resultado
    syscall

    jal resultado

    li $v0, 10
    syscall

resultado:
    li $t0, 0
    li $t1, 4 # Número de candidatos

print_loop:
    beq $t0, $t1, end_print_loop

    # Carregar o endereço do nome do candidato a partir do array candidatos
    sll $t2, $t0, 2         # t2 = t0 * 4 (tamanho de palavra)
    la $t3, candidatos      # Carrega o endereço base do array de candidatos
    lw $a0, 0($t3)          # Carrega o endereço da string do candidato
    lw $a0, 0($t3)          # Carrega o endereço do ponteiro de string
    add $t3, $t3, $t2       # Adiciona o deslocamento do índice ao endereço base
    lw $a0, 0($t3)          # Carrega o ponteiro da string
    li $v0, 4               # Prepara syscall para imprimir string
    syscall

    # Imprimir os votos
    sll $t3, $t0, 2
    la $t4, votos
    add $t4, $t4, $t3
    lw $a0, 0($t4)
    li $v0, 1
    syscall

    # Imprimir quebra de linha
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j print_loop

end_print_loop:
    jr $ra
