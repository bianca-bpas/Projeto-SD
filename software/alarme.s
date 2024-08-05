add $2, $1, $1
lw $3, 0($0)
sw $2, 0($0)
beq $2, $3, 2    #compara o registrador $2 com o $3
j 1
