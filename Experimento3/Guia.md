# Experimento 3 — Laboratório de Microcontroladores

**Disciplina:** Laboratório de Microcontroladores e Microprocessadores  
**Microcontrolador:** AT89C52 (família 8051)  
**Linguagem:** Assembly 8051  
**Ferramentas:** MCU 8051 IDE e MAXLOADER

## 1. Objetivo

Estudar o funcionamento das interrupções no microcontrolador 8051 por meio de dois programas independentes.

- **Parte 1 — Interrupção Externa INT0:** controlar uma sequência de oito LEDs, invertendo seu sentido a cada pressionamento válido de um botão.
- **Parte 2 — Interrupção do Timer 0:** utilizar o temporizador de 16 bits para alternar o estado de um LED a cada transbordamento.

### Arquivos do experimento

| Arquivo | Descrição |
|---|---|
| [Parte1_Sequencial_INT0.asm](./Parte1_Sequencial_INT0.asm) | Sequência de oito LEDs com interrupção externa |
| [Parte2_Timer0.asm](./Parte2_Timer0.asm) | LED piscando por interrupção do Timer 0 |

> **Importante:** os programas são independentes. Compile e grave apenas um de cada vez.

---

## 2. Materiais necessários

| Quantidade | Componente |
|---|---|
| 1 | AT89C52, encapsulamento DIP-40 |
| 8 | LEDs vermelhos |
| 8 | Transistores BC548 |
| 8 | Resistores de 470 Ω |
| 17 | Resistores de 4,7 kΩ |
| 1 | Resistor de 10 kΩ |
| 1 | Capacitor eletrolítico de 10 µF |
| 2 | Capacitores cerâmicos de 33 pF |
| 1 | Capacitor cerâmico de 100 nF |
| 1 | Cristal oscilador |
| 1 | Botão normalmente aberto |
| 2 | Protoboards |
| — | Jumpers e fonte regulada de 5 V |

Também serão utilizados multímetro, computador e gravador compatível com o AT89C52.

**Observação:** os resistores de 470 Ω e 4,7 kΩ e os pull-ups adicionais correspondem à montagem recomendada no roteiro didático. O esquema original do enunciado utiliza valores diferentes. Confirme os componentes e a montagem com o professor caso seja necessário seguir estritamente o circuito original.

---

## 3. Pinos importantes do AT89C52

| Pino físico | Identificação | Função |
|---|---|---|
| 40 | VCC | Alimentação +5 V |
| 20 | GND | Terra |
| 31 | EA/VPP | Conectar a +5 V |
| 9 | RST | Reset, ativo em nível alto |
| 19 | XTAL1 | Oscilador |
| 18 | XTAL2 | Oscilador |
| 12 | P3.2 / INT0 | Entrada da interrupção externa |
| 1–8 | P1.0–P1.7 | Saídas dos oito LEDs |

### Associação dos LEDs

| LED | Porta | Pino físico |
|---|---|---|
| LED1 | P1.0 | 1 |
| LED2 | P1.1 | 2 |
| LED3 | P1.2 | 3 |
| LED4 | P1.3 | 4 |
| LED5 | P1.4 | 5 |
| LED6 | P1.5 | 6 |
| LED7 | P1.6 | 7 |
| LED8 | P1.7 | 8 |

Na montagem proposta, **LED1 fica à direita e LED8 à esquerda**.

A sequência inicial é:

`LED1 → LED2 → LED3 → LED4 → LED5 → LED6 → LED7 → LED8 → LED1`

A sequência é circular, sem inversão automática ao atingir as extremidades.

---

## 4. Montagem do circuito

### 4.1. Circuito mínimo do microcontrolador

Com a alimentação desligada:

1. Posicionar o AT89C52 na protoboard, observando o chanfro e a identificação do pino 1.
2. Conectar VCC (pino 40) à alimentação de +5 V.
3. Conectar GND (pino 20) ao terra.
4. Conectar EA/VPP (pino 31) a +5 V.
5. Instalar o cristal entre XTAL1 (19) e XTAL2 (18).
6. Conectar um capacitor de 33 pF de cada terminal do cristal ao GND.
7. Conectar o resistor de 10 kΩ entre RST (9) e GND.
8. Conectar o capacitor de 10 µF entre +5 V e RST, com o terminal positivo em +5 V.
9. Instalar o capacitor de desacoplamento de 100 nF entre VCC e GND, próximo ao CI.

**Atenção:** confira a continuidade dos barramentos das protoboards. Alguns trilhos são interrompidos no meio e precisam de jumpers de ligação.

### 4.2. Montagem dos LEDs

Cada LED é acionado por um transistor NPN BC548.

Conexões de cada canal:

- +5 V → resistor de 470 Ω → ânodo do LED.
- Cátodo do LED → coletor do BC548.
- Emissor do BC548 → GND.
- Saída P1.x → resistor de 4,7 kΩ → base do BC548.
- Resistor adicional de pull-up de 4,7 kΩ entre P1.x e +5 V.

Na pinagem usual do BC548 TO-92, olhando a face plana de frente e com os terminais para baixo, a ordem é **C — B — E**. Confirme a pinagem do componente efetivamente disponível.

**Recomendação:** monte e teste primeiro apenas o LED1. Com o sinal ainda desconectado do microcontrolador, o pull-up tende a acender o LED; ao aterrar o nó de sinal, ele deve apagar. Desligue a alimentação antes de corrigir conexões.

Depois de validar o primeiro canal, monte os demais sete seguindo o mesmo padrão.

### 4.3. Botão da interrupção INT0

O botão utiliza a entrada P3.2, pino físico 12.

Conexões:

- P3.2 → resistor de pull-up de 4,7 kΩ → +5 V.
- P3.2 → botão normalmente aberto → GND.

Funcionamento:

| Estado | Nível lógico em P3.2 |
|---|---|
| Botão solto | 1 |
| Botão pressionado | 0 |

A interrupção INT0 é configurada para detectar a borda de descida (1 → 0).

Em botões de quatro terminais, identifique os pares internos com o multímetro antes de montar.

### 4.4. Verificações antes de programar

- [ ] Alimentação em aproximadamente 5 V
- [ ] Todos os terras interligados
- [ ] Barramentos sem curto-circuito
- [ ] Pino EA/VPP conectado a +5 V
- [ ] Reset conectado corretamente
- [ ] Cristal e capacitores instalados
- [ ] Polaridade dos LEDs conferida
- [ ] Pinagem dos transistores conferida
- [ ] P1.0–P1.7 conectados aos LEDs correspondentes
- [ ] P3.2 conectado ao botão
- [ ] Botão solto = nível alto; pressionado = nível baixo

---

## 5. Parte 1 — Sequencial de LEDs com INT0

**Arquivo:** [Parte1_Sequencial_INT0.asm](./Parte1_Sequencial_INT0.asm)

### Funcionamento esperado

Inicialmente, somente LED1 permanece aceso.

A cada aproximadamente 100 ms, o próximo LED acende e o anterior apaga.

O programa utiliza:

- `RL A`: rotação dos bits para a esquerda.
- `RR A`: rotação dos bits para a direita.
- `INT0`: interrupção externa para detectar o botão.
- `DIRECAO`: flag que determina o sentido.
- `PENDENTE` e `SOLTURA`: controle do acionamento e da liberação do botão.

O programa faz filtragem por software, exigindo aproximadamente 20 ms de pressão estável.

Cada pressionamento válido deve inverter o sentido **uma única vez**.

### Configuração conforme o cristal

Antes de compilar, verifique a frequência do cristal disponível no laboratório.

| Cristal | N_EXT | N_INT |
|---|---|---|
| 11,059 MHz | 2 | 226 |
| 11,0592 MHz | 2 | 226 |
| 12 MHz | 2 | 245 |
| 22 MHz | 4 | 226 |
| 22,1184 MHz | 4 | 227 |

Valores inicialmente utilizados:

```asm
N_EXT EQU 2
N_INT EQU 226
```

Esses valores são apropriados para aproximadamente 11,0592 MHz, com intervalo nominal de 100,16 ms.

**Atenção:** a tabela considera o AT89C52 clássico (12T). Verifique a frequência real do cristal e a variante do microcontrolador.

### Testes da Parte 1

- [ ] Apenas um LED aceso por vez
- [ ] Sequência começa pelo LED1
- [ ] Sequência inicialmente para a esquerda
- [ ] Intervalo próximo de 100 ms por LED
- [ ] Após LED8, retorna ao LED1
- [ ] Uma pressão inverte o sentido
- [ ] Manter o botão pressionado não causa inversões repetidas
- [ ] Soltar e pressionar novamente causa outra inversão
- [ ] O LED atual não é reiniciado após a inversão

**Observação:** a inversão não precisa ocorrer visualmente no instante da pressão. O programa valida o botão e aplica o novo sentido no próximo avanço da sequência.

---

## 6. Parte 2 — Interrupção do Timer 0

**Arquivo:** [Parte2_Timer0.asm](./Parte2_Timer0.asm)

### Funcionamento esperado

O programa utiliza o Timer 0 no modo de 16 bits para alternar o estado do LED conectado à porta P1.0.

Configuração principal:

```asm
MOV TMOD,#01H
MOV TH0,#00H
MOV TL0,#00H
```

- `TMOD = 01H`: seleciona Timer 0 no modo 1 (16 bits).
- `TH0` e `TL0`: registradores do contador.
- `ET0`: habilita a interrupção do Timer 0.
- `EA`: habilita globalmente as interrupções.
- `TR0`: inicia a contagem.
- `TF0`: flag de transbordamento.

O contador vai de `0000H` até `FFFFH`. No transbordamento, é executada a rotina de interrupção localizada no vetor `000BH`.

A instrução:

```asm
CPL P1.0
```

Inverte o estado do LED1 a cada interrupção.

### Intervalo de alternância

| Cristal | Tempo aceso/apagado | Período completo |
|---|---|---|
| 11,0592 MHz | 71,111 ms | 142,222 ms |
| 12 MHz | 65,536 ms | 131,072 ms |
| 22 MHz | 35,747 ms | 71,494 ms |
| 22,1184 MHz | 35,556 ms | 71,111 ms |

Os valores são nominais para o núcleo clássico 12T.

**Importante:** a Parte 2 não exige alteração de constantes entre essas frequências. O intervalo é determinado pelo clock utilizado.

### Testes da Parte 2

- [ ] Apenas LED1 (P1.0) alterna
- [ ] LED2 até LED8 permanecem apagados
- [ ] Timer 0 configurado no modo 1
- [ ] Interrupção habilitada por `ET0` e `EA`
- [ ] Contagem iniciada por `TR0`
- [ ] LED alterna a cada transbordamento
- [ ] Intervalo compatível com a frequência do cristal

O LED pode piscar rapidamente. Quando possível, utilize um osciloscópio ou analisador lógico para observar o sinal de P1.0.

---

## 7. Compilação e gravação

### 7.1. MCU 8051 IDE

1. Abrir o MCU 8051 IDE.
2. Criar ou configurar um projeto para AT89C52 ou núcleo 8052 clássico compatível.
3. Abrir o arquivo `.asm` correspondente à parte desejada.
4. Conferir a frequência do cristal.
5. Ajustar `N_EXT` e `N_INT`, caso esteja executando a Parte 1.
6. Montar/compilar o programa.
7. Corrigir eventuais erros de montagem.
8. Localizar o arquivo `.hex` gerado.
9. Confirmar se o HEX corresponde à versão mais recente do código.

**Não reúna os dois programas no mesmo projeto executável.**

Caso o montador informe símbolos como `EA`, `EX0` ou `TR0` indefinidos, verifique as definições do dispositivo no projeto.

### 7.2. MAXLOADER

1. Desligar a alimentação da protoboard.
2. Retirar cuidadosamente o AT89C52.
3. Abrir o MAXLOADER.
4. Selecionar exatamente o dispositivo AT89C52 compatível com o CI disponível.
5. Inserir o microcontrolador no gravador conforme a orientação indicada no equipamento.
6. Carregar o arquivo HEX recém-gerado.
7. Executar as operações de apagamento, programação e verificação indicadas pelo gravador.
8. Confirmar que a verificação foi concluída com sucesso.
9. Retirar o CI do gravador.
10. Recolocá-lo na protoboard com a alimentação desligada.
11. Conferir a orientação e energizar o circuito.

**Atenção:** AT89C52 e AT89S52 não são equivalentes para o procedimento de gravação. Selecione o dispositivo correto no MAXLOADER.

O procedimento e os nomes dos comandos podem variar conforme a versão dos programas e o gravador disponível.

---

## 8. Problemas comuns

| Problema | O que verificar |
|---|---|
| Nenhum LED acende | Alimentação, GND, reset, EA, cristal e gravação |
| Somente um LED não acende | Polaridade do LED, BC548, resistores e jumper |
| Todos os LEDs ficam acesos | Saídas de P1, execução do programa e circuito |
| Sequência muito rápida ou lenta | Cristal e constantes `N_EXT`/`N_INT` |
| Botão não funciona | P3.2, pull-up, contatos, GND, `EX0` e `EA` |
| Botão inverte várias vezes | Repiques, filtragem, ruído e conexões |
| Sequência no sentido contrário | Ordem física dos LEDs na protoboard |
| Timer 0 não alterna o LED | `TMOD`, `TH0`, `TL0`, `ET0`, `EA` e `TR0` |
| Gravação falha | Modelo do CI, posicionamento e contatos do gravador |
| Circuito falha intermitentemente | Barramentos, jumpers, reset e oscilador |

**Dica:** ao encontrar uma falha, verifique inicialmente a alimentação, o reset e as conexões físicas antes de modificar o código.

---

## 9. Resultados e medições

Preencher durante a execução do experimento.

| Grandeza | Valor medido/observado |
|---|---|
| Frequência do cristal | |
| Variante do AT89C52 | |
| Tensão VCC | |
| Tensão no pino EA/VPP | |
| RST após estabilização | |
| INT0 com botão solto | |
| INT0 com botão pressionado | |
| Tensão no resistor de 470 Ω | |
| Intervalo entre LEDs — Parte 1 | |
| Intervalo de alternância — Parte 2 | |
| Inversão de sentido funcionando? | |
| Verificação da gravação concluída? | |

Para estimar a corrente do LED a partir da tensão medida no resistor:

`I_LED = V_R / 470 Ω`

---

## 10. Checklist final

### Antes de ligar

- [ ] Conferir a montagem e a polaridade dos componentes
- [ ] Verificar a alimentação de 5 V
- [ ] Conferir o cristal disponível
- [ ] Verificar se os barramentos estão interligados
- [ ] Confirmar ausência de curtos

### Parte 1

- [ ] Conferir as constantes do cristal
- [ ] Compilar e gerar o HEX
- [ ] Gravar e verificar o AT89C52
- [ ] Observar a sequência dos oito LEDs
- [ ] Testar a inversão por INT0
- [ ] Testar botão mantido pressionado
- [ ] Registrar os resultados

### Parte 2

- [ ] Compilar o segundo programa
- [ ] Gerar o novo HEX
- [ ] Desligar o circuito e regravar o AT89C52
- [ ] Confirmar alternância de P1.0
- [ ] Verificar os demais LEDs apagados
- [ ] Registrar o intervalo observado

---

## 11. Referências

- Enunciado da Experiência 03 — Laboratório de Microcontroladores e Microprocessadores, EMC/UFG.
- Roteiro didático do Experimento 3 — Interrupção externa INT0 e Timer 0 no AT89C52.
- Atmel — Datasheet do AT89C52.
- Atmel — 8051 Microcontrollers Hardware Manual.
- Datasheets dos componentes BC548 e LEDs utilizados.

> **Nota:** este README é um guia rápido de consulta. Os esquemas elétricos, os mapas completos das protoboards e as justificativas técnicas detalhadas estão no roteiro didático. A compilação no software do laboratório, a gravação e os testes físicos ainda precisam ser realizados.
