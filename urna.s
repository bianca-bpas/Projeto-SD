# ERROS PARA CORRIGIR:
# Impressão dos votos
.data
newline: .asciiz "\n"

# Senha para encerrar o programa
ENCERRAR: .word 12345

# Array com o nome dos candidatos e quantidade de votos, simula um dicionário onde os índices são as keys
candidatos: 
    .asciiz "C1\n"
    .asciiz "C2\n"
    .asciiz "C3\n"
    .asciiz "Nulo\n"
votos: .word 0, 0, 0, 0, 0 # C1, C2, C3, Nulo, Branco

msg_digite_voto: .asciiz "Digite seu voto (0-3) ou 4 para branco: \n"
msg_confirmar: .asciiz "Aperte confirmar (C): \n"
confirma: .byte 'C'
msg_resultado: .asciiz "\nResultado da votação:\n"

.text
.globl main
main:
    # Inicializa a variável voto com -1
    li $t1, -1          # $t1 = valor do voto do usuário

loop: 
    # ----------- Corpo do loop: recebe o voto do usuário
    # Imprimir a mensagem de digitar voto
    li $v0, 4
    la $a0, msg_digite_voto
    syscall

    # Leitura do voto do usuário
    li $v0, 5
    syscall
    move $t1, $v0       # $t1 = valor digitado pelo usuário

    # Verifica se o voto é igual ao valor de ENCERRAR
    lw $t0, ENCERRAR
    beq $t0, $t1, end_loop

    # Verifica se o voto está dentro do intervalo válido (0-4)
    blt $t1, 0, loop
    bgt $t1, 4, loop

    # Imprimir quebra de linha
    li $v0, 4
    la $a0, newline
    syscall

    # Imprimir a mensagem de confirmar voto
    li $v0, 4
    la $a0, msg_confirmar
    syscall

    # Simulando voto confirmado
    li $v0, 12
    syscall
    li $t2, 'C'
    bne $v0, $t2, loop

    # Incrementa o voto no array
    sll $t2, $t1, 2        # Multiplica $t1 por 4 (tamanho de palavra) para obter o índice do array
    la $t3, votos          # Carrega o endereço base do array votos
    add $t3, $t3, $t2      # Adiciona o índice ao endereço base
    lw $t4, 0($t3)         # Carrega o valor atual do array no índice especificado
    addi $t4, $t4, 1       # Incrementa o valor
    sw $t4, 0($t3)         # Armazena o valor de volta no array

    # Volta ao início do loop
    j loop

end_loop:
    # Após sair do loop, imprime a mensagem de resultado da votação
    li $v0, 4
    la $a0, msg_resultado
    syscall

    # Chama a função para imprimir os votos dos candidatos
    jal resultado

    # Fim do programa
    li $v0, 10         # Código da syscall para sair do programa
    syscall

resultado:
    # Imprimir os votos dos candidatos
    li $t0, 0          # Índice inicial do array votos
    li $t1, 5          # Número de candidatos

print_loop:
    beq $t0, $t1, end_print_loop  # Se todos os candidatos foram impressos, saia do loop

    # Imprimir nome do candidato
    la $a0, candidatos
    add $a0, $a0, $t0
    li $v0, 4
    syscall

    # Imprimir os votos
    sll $t2, $t0, 2
    la $t3, votos
    add $t3, $t3, $t2
    lw $a0, 0($t3)
    li $v0, 1
    syscall

    # Imprimir quebra de linha
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1  # Incrementa o índice
    j print_loop

end_print_loop:
    jr $ra             # Retorna da função
