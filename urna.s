.data
newline: .asciiz "\n"
ENCERRAR: .word 12345

# Strings dos candidatos
candidato1: .asciiz "C1: "
candidato2: .asciiz "C2: "
candidato3: .asciiz "C3: "

# Array de endereços dos nomes dos candidatos
candidatos: .word candidato1, candidato2, candidato3

votos: .word 0, 0, 0 # C1, C2, C3

msg_confirmar: .asciiz "\nAperte confirmar (C): "
confirma: .byte 'C'
msg_voto_recebido: .asciiz "\nVoto recebido: "
msg_resultado: .asciiz "\nResultado da votação:\n"

# Lista de votos predefinida
lista_de_votos: .word 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1

.text
.globl main
main:
    li $t0, 0                # Índice da lista de votos
    li $t1, 23               # Número de votos na lista
    la $t2, lista_de_votos   # Endereço da lista de votos
    lw $t3, ENCERRAR         # Carregar o valor de ENCERRAR

loop: 
    beq $t0, $t1, end_loop   # Se todos os votos foram processados, fim do loop

    lw $t4, 0($t2)           # Carregar o próximo voto da lista
    beq $t4, $t3, end_loop   # Se o voto for ENCERRAR, fim do loop

    # Imprimir "Voto recebido: "
    li $v0, 4
    la $a0, msg_voto_recebido
    syscall
    li $v0, 1
    move $a0, $t4
    syscall

    # Imprimir mensagem de confirmação
    li $v0, 4
    la $a0, msg_confirmar
    syscall

    # Simular confirmação com 'C'
    lb $t5, confirma
    li $t6, 'C'
    beq $t5, $t6, confirmar

    j loop

confirmar:
    sll $t7, $t4, 2          # Calcular o deslocamento no array de votos
    la $t8, votos            # Carregar o endereço base do array de votos
    add $t9, $t8, $t7        # Calcular o endereço específico do candidato
    lw $t4, 0($t9)           # Carregar o valor atual dos votos
    addi $t4, $t4, 1         # Incrementar o voto
    sw $t4, 0($t9)           # Salvar o voto atualizado

    addi $t2, $t2, 4         # Avançar para o próximo voto na lista
    addi $t0, $t0, 1         # Incrementar o índice do loop
    j loop                   # Repetir o loop

end_loop:
    # Imprimir resultado da votação
    li $v0, 4
    la $a0, msg_resultado
    syscall

    jal resultado

    li $v0, 10
    syscall

resultado:
    li $t0, 0
    li $t1, 3 # Número de candidatos

print_loop:
    beq $t0, $t1, end_print_loop

    # Carregar o endereço do nome do candidato a partir do array candidatos
    sll $t2, $t0, 2         # t2 = t0 * 4 (tamanho de palavra)
    la $t3, candidatos      # Carrega o endereço base do array de candidatos
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
