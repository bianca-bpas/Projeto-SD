# ProjetoSD-CIN-UFPE
Projeto final da disciplina de SD

# Objetivo
- Modelar e simular em Verilog um microprocessador MIPS que seja capaz de executar um programa que implemente uma função relacionada à temática da sua equipe. Este projeto integrará os conhecimentos adquiridos ao longo da disciplina, abrangendo desde a lógica digital até a microarquitetura de um processador.
- Programa escolhido: Simulador de urna digital.
- Software escrito com a linguagem Python.
- Adaptado para a linguagem MIPS Assembly.

# Escopo do Projeto
O projeto consiste nas seguintes etapas:

## Estudo da Arquitetura e Microarquitetura MIPS:
- Utilizar o capítulo 6 do livro "Projeto Digital e Arquitetura de Computadores" de David Money Harris e Sarah L. Harris, que cobre a arquitetura (conjunto de instruções) do processador MIPS.
- Utilizar o capítulo 7 do livro "Projeto Digital e Arquitetura de Computadores" de David Money Harris e Sarah L. Harris, que cobre a microarquitetura MIPS. Este capítulo fornecerá a base teórica necessária para entender como cada instrução MIPS funciona.

![image](https://github.com/user-attachments/assets/cc94d693-6a4a-40ad-ad42-a8e778f3cd04)

## Seleção do programa a ser executado:
- [x] (Bianca) - Escrever um programa simples em alto nível (Python) que contenha pelo menos uma função, condicionais (if, etc) e que esteja alinhado com a temática da equipe.
- [x] (Bianca) - Escolher uma função específica que o microprocessador MIPS será capaz de executar. Esta função deve ser composta por um conjunto de instruções MIPS (adaptar o código para Assembly).

## Módulos em Verilog
- [x] (Bianca) - PC, Instruction Memory, Register File, Data Memory, Sign Extend, ALU, PCPlus4, PCBranch, Control Unit.

## Integração das Unidades de Controle e Dados:
- [x] (Vinícius) - Integrar a unidade de controle com a unidade de dados para formar o microprocessador completo, garantindo que as instruções sejam executadas corretamente.

## Assembler
- [x] (Paula) - Convertendo o código do projeto em Assembly para binário.
    () - Integrar a unidade de controle com a unidade de dados para formar o microprocessador completo, garantindo que as instruções sejam executadas corretamente.


## Simulação e Testes:
- [ ] (Vinícius) - Montagem dos Testbench para a simulação.
- [ ] (Vinícius) - Simulação do microprocessador, utilizando o Software ModelSim.
- [ ] () - Teste e Depuração do Software Assembly no microprocessador.

## Relatório do Projeto:
- [ ] (Paula) - Relatório especificando cada arquivo feito e lógica utilizada, além, de prints com o teste feito da função escolhida. O relatório deverá ser encerrado com uma conclusão que informe os conhecimentos adquiridos durante a realização do projeto.

# Ferramentas e Recursos
  * Livro Texto: "Projeto Digital e Arquitetura de Computadores" de David Money Harris e Sarah L. Harris, capítulo 6 e 7.
  * Software de Simulação: Utilização de softwares como ModelSim ou Quartus para simulação e teste do microprocessador.
  * Material de Apoio: Slides, anotações de aula e outros recursos fornecidos durante a disciplina.

# Entregáveis
- Arquivo .zip contendo os códigos utilizados.
- Relatório do projeto.
