; Entrega Final
; Maria Eduarda Amadio 16228873

ORG 0000H
    LJMP MAIN

ORG 001BH
    ACALL RESET_CONT  ; A interrupção chama o reset quando chega em 10
    RETI

;_________________________

ORG 0030H
MAIN:
    ; Timer1 modo 2 (8 bits auto-reload) contador (C/T=1)
    MOV TMOD, #01100000B 

    ; Para interromper em 10 pulsos, começamos em 246 (F6H)
    MOV TL1, #0F6H
    MOV TH1, #0F6H    ; Valor de reload automático

    SETB ET1          ; Habilita interrupção do Timer 1
    SETB EA           ; Habilita interrupção global
    SETB TR1          ; Liga contador

    CLR F0            ; Sentido inicial
    MOV DPTR, #TABELA

;__________________________

LOOP:
    ACALL VERIFICA_SW

    ; MOSTRA NO DISPLAY
    MOV A, TL1
    CLR C
    SUBB A, #0F6H
    MOVC A, @A+DPTR

    ; INDICA SENTIDO NO PONTO (P1.7)
    ; Se F0=0 -> Ponto aceso (bit=0). Se F0=1 -> Ponto apagado (bit=1)
    MOV C, F0
    MOV ACC.7, C
    MOV P1, A

    SJMP LOOP

;_______________________

VERIFICA_SW:
    MOV C, P2.0
    JB F0, TESTA_S1
    JC MUDOU          ; Se era 0 e foi pra 1, mudou
    RET
TESTA_S1:
    JNC MUDOU         ; Se era 1 e foi pra 0, mudou
    RET

MUDOU:
    ACALL MUDA_DIRECAO
    RET

;__________________________

MUDA_DIRECAO:
    MOV C, P2.0
    MOV F0, C
    ACALL RESET_CONT  ; Reseta contagem ao trocar sentido

    JNB F0, SENTIDO_0 ; Lógica invertida

SENTIDO_1:
    SETB P3.0
    CLR P3.1
    RET

SENTIDO_0:
    CLR P3.0
    SETB P3.1
    RET

;_________________________

RESET_CONT:
    CLR TR1
    MOV TL1, #0F6H    ; Reinicia no valor base
    SETB TR1
    RET

;_________________________

TABELA:
    DB 11000000B ; 0
    DB 11111001B ; 1
    DB 10100100B ; 2
    DB 10110000B ; 3
    DB 10011001B ; 4
    DB 10010010B ; 5
    DB 10000010B ; 6
    DB 11111000B ; 7
    DB 10000000B ; 8
    DB 10010000B ; 9

END
