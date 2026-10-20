N_EXT       EQU 2
N_INT       EQU 226

DIRECAO     BIT 00H
PENDENTE    BIT 01H
SOLTURA     BIT 02H

            ORG 0000H
            LJMP INICIO

            ORG 0003H
            LJMP ISR_INT0

            ORG 0030H

INICIO:
            MOV IE,#00H
            MOV SP,#5FH
            MOV PSW,#00H
            MOV P1,#00H
            CLR DIRECAO
            CLR PENDENTE
            CLR SOLTURA
            MOV R2,#20
            MOV R3,#20
            MOV R4,#100
            MOV A,#01H
            MOV P1,A
            SETB P3.2
            SETB IT0
            CLR IE0
            JB P3.2,ARMAR
            SETB PENDENTE
            SETB SOLTURA
            SJMP HABILITAR

ARMAR:
            SETB EX0

HABILITAR:
            SETB EA

PRINCIPAL:
            LCALL ATRASO
            LCALL BOTAO
            DJNZ R4,PRINCIPAL
            MOV R4,#100
            JB DIRECAO,DIREITA
            RL A
            SJMP MOSTRAR

DIREITA:
            RR A

MOSTRAR:
            MOV P1,A
            SJMP PRINCIPAL

ISR_INT0:
            CLR EX0
            SETB PENDENTE
            RETI

BOTAO:
            JNB PENDENTE,FIM_BOTAO
            JB SOLTURA,LIBERACAO
            JB P3.2,NAO_PRESSIONADO
            MOV R3,#20
            DJNZ R2,FIM_BOTAO
            CPL DIRECAO
            SETB SOLTURA
            RET

NAO_PRESSIONADO:
            MOV R2,#20
            DJNZ R3,FIM_BOTAO
            SJMP REARMAR

LIBERACAO:
            JNB P3.2,AINDA_PRESSIONADO
            DJNZ R3,FIM_BOTAO
            SJMP REARMAR

AINDA_PRESSIONADO:
            MOV R3,#20
            RET

REARMAR:
            MOV R2,#20
            MOV R3,#20
            CLR SOLTURA
            CLR PENDENTE
            CLR IE0
            SETB EX0

FIM_BOTAO:
            RET

ATRASO:
            MOV R6,#N_EXT

LA_EXT:
            MOV R7,#N_INT

LA_INT:
            DJNZ R7,LA_INT
            DJNZ R6,LA_EXT
            RET

            END
