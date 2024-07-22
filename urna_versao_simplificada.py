ENCERRAR = 12345

candidates = {
    1: "C1", 
    2: "C2", 
    3: "C3",
    0: "null"  
}

memoria = {
    "C1":     0, 
    "C2":     0, 
    "C3":     0, 
    "null":   0,
    "Branco": 0,
}

botons = {"B":"Branco","C": "Confirmar", "R": "Refazer"}

voto = 0

while voto != ENCERRAR:
    print("Digite seu voto: ")
    try:
        voto = int(input())
    except ValueError:
        print("Voto inválido, digite um número.")
        continue

    if voto in candidates:
        candidate = candidates[voto]
        print("Aperte confirmar (C) ou Branco (B): ")
        botom = input().upper()
        
        if botom == "C":
            memoria[candidate] += 1
        elif botom == "B":
            memoria["Branco"] += 1
        else:
            print("Botão inválido, voto não registrado.")
    elif voto == 0:
        memoria["nul"] += 1
    elif voto != ENCERRAR:
        print("Candidato não encontrado. Digite novamente.")

print("\nResultado da votação:")
for candidato, votos in memoria.items():
    print(f"{candidato} : {votos}")
