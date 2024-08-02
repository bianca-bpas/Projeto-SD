# Definição de constantes e variáveis
ENCERRAR = 12345

candidato1 = "C1"
candidato2 = "C2"
candidato3 = "C3"

candidatos = [candidato1, candidato2, candidato3]

votos = [0, 0, 0] 

msg_confirmar = "Aperte confirmar (C): "
confirma = 'C'
msg_voto_recebido = "Voto recebido:"
msg_resultado = "Resultado da votação:"

# Lista de votos pré-definida (20 votos)
lista_de_votos = [0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1]

# Simulação dos votos
for voto in lista_de_votos:
    if voto == ENCERRAR:
        break
    
    print(msg_voto_recebido, voto)
    print(msg_confirmar)
    opcao = 'C'  # Simulando a confirmação do voto
        
    if opcao == confirma:
        votos[voto] += 1

print(msg_resultado)
for i in range(0, 3):
    print(f"{candidatos[i]}: {votos[i]}")
print()
