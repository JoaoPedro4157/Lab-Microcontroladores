ORG 0000H
        LJMP INICIO

        ORG 000BH
        LJMP ISR_T0

        ORG 0030H

INICIO:
        MOV IE,#00H
        MOV SP,#5FH
        MOV PSW,#00H
        MOV P1,#00H
        CLR TR0
        MOV TMOD,#01H
        MOV TH0,#00H
        MOV TL0,#00H
        CLR TF0
        SETB ET0
        SETB EA
        SETB TR0

ESPERA:
        SJMP ESPERA

ISR_T0:
        CPL P1.0
        RETI

        END
