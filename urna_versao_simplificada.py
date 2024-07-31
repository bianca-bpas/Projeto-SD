ENCERRAR = 12345

candidato1 = "C1"
candidato2 = "C2"
candidato3 = "C3"

candidatos = [candidato1, candidato2, candidato3]

votos = [0, 0, 0] 

msg_digite_voto = "Digite seu voto (0-2): \n"
msg_confirmar = "Aperte confirmar (C): "
confirma = 'C'
msg_resultado = "Resultado da votação:"

print(msg_digite_voto)
voto = int(input())
while voto != ENCERRAR:
    print(msg_confirmar)
    opcao = input().upper()
        
    if opcao == confirma:
        votos[voto] += 1

    print(msg_digite_voto)
    voto = int(input())

print(msg_resultado)
for i in range(0,3):
    print(candidatos[i])
    print(votos[i])
print()