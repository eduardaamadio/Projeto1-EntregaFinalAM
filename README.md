# Projeto1-EntregaFinalAM
## Explicação
Este projeto controla um sistema de dosagem usando o microcontrolador 8051 no simulador EdSim51. O sistema gerencia o sentido do motor, conta voltas via interrupção e exibe os dados em um display de 7 segmentos.

Primeiro, o Timer 1 foi configurado no Modo 2 (8 bits com auto-reload) e como contador (C/T=1), então ele fica "ouvindo" os pulsos que vêm do motor.
Para resetar a cada 10 voltas, foi usado o valor 246 (0F6H). Então começa em 246, conta 10 pulsos até chegar em 256 (estouro), ativa a interrupção e volta sozinho para o 246.
Para resetar a cada 10 voltas, foi usado o valor 246 (0F6H), carregado tanto em TL1 quanto em TH1. Assim, ele começa em 246, conta 10 pulsos até chegar em 256 (estouro), ativa a interrupção e volta automaticamente para 246 por causa do auto-reload.

As interrupções são habilitadas com SETB ET1 (Timer 1) e SETB EA (global), e o contador é iniciado com SETB TR1.
O bit F0 é inicializado com CLR F0 para definir o sentido inicial, e o registrador DPTR recebe o endereço da tabela com MOV DPTR, #TABELA.

No loop principal (LOOP), o código fica "chamando" a sub-rotina VERIFICA_SW (ACALL VERIFICA_SW), que fica lendo a chave SW0 conectada em P2.0.
Se houver mudança, o código vai para MUDOU e chama ACALL MUDA_DIRECAO.

Na rotina MUDA_DIRECAO, o novo valor da chave é salvo em F0 (MOV F0, C) e a contagem é zerada chamando ACALL RESET_CONT, garantindo que não mistura voltas de sentidos diferentes.

Depois, o sentido do motor é controlado pelos pinos P3.0 e P3.1:

SETB P3.0 e CLR P3.1 para um sentido

CLR P3.0 e SETB P3.1 para o outro

A escolha é feita com JNB F0, SENTIDO_0.
A rotina RESET_CONT para o contador (CLR TR1), recarrega TL1 com 0F6H e liga novamente com SETB TR1, reiniciando a contagem corretamente.

Para mostrar os números no display, o sistema pega o valor atual do contador com MOV A, TL1.
Como o contador está entre 246 e 255, o código limpa o carry (CLR C) e faz SUBB A, #0F6H para converter essa faixa em valores de 0 a 9.
Depois, com MOVC A, @A+DPTR, o valor é usado como índice na tabela (TABELA), que contém os padrões binários dos números para o display de 7 segmentos.

A sinalização do sentido de rotação é feita usando o ponto decimal do display. O valor de F0 é movido para o carry (MOV C, F0) e depois para o bit 7 do acumulador (MOV ACC.7, C). Assim:

F0 = 0 → ponto aceso

F0 = 1 → ponto apagado

Por fim, o valor completo é enviado para o display com MOV P1, A.
