# Projeto1-EntregaFinalAM
## Explicação
Este projeto controla um sistema de dosagem usando o microcontrolador 8051 no simulador EdSim51. O sistema gerencia o sentido do motor, conta voltas via interrupção e exibe os dados em um display de 7 segmentos.

Primeiro, o Timer 1 foi configurado no Modo 2 (8 bits com auto-reload). Eu setei ele como contador (C/T=1), então ele fica "ouvindo" os pulsos que vêm do motor.
Como o professor pediu para resetar a cada 10 voltas, eu usei o valor 246 (0F6H). A lógica é: ele começa em 246, conta 10 pulsos até chegar em 256 (estouro), ativa a interrupção e volta sozinho para o 246.

2. O Uso de Interrupções
Diferente dos outros checkpoints, agora eu usei a interrupção do Timer 1 (o vetor 001BH). Sempre que o motor completa o ciclo de 10 voltas, o hardware avisa o código e chama a sub-rotina RESET_CONT. Isso deixa o controle muito mais limpo porque o processador não precisa ficar conferindo o número o tempo todo.

3. Controle de Sentido (Chave SW0)
No LOOP principal, eu fico chamando a VERIFICA_SW. Ela olha para a chave P2.0.

Se o operador mudar a chave de lado, o sistema detecta essa transição (usando o bit F0 como memória).
Quando muda o sentido, o motor inverte (via pinos P3.0 e P3.1) e a contagem de voltas zera na hora, para não misturar as voltas de um sentido com o outro.

4. Display e o Ponto Decimal
Para mostrar os números de 0 a 9, eu pego o valor atual do contador (TL1), subtraio a base de 246 para ajustar a escala e busco o padrão de bits na minha TABELA (ânodo comum).

A sacada legal aqui é a sinalização visual: eu usei o bit 7 do Acumulador (ACC.7) para controlar o ponto decimal do display (P1.7).

Se o motor está em um sentido, o ponto acende.

Se mudar o sentido, o ponto apaga.
Tudo isso acontece no mesmo instante que o número é enviado para a porta P1.

5. Resumo das Sub-rotinas
RESET_CONT: Para o motor rapidinho, reseta o valor do contador e liga de novo.

MUDA_DIRECAO: Atualiza quem é o F0 e decide qual pino do motor recebe sinal.

TABELA: Contém os códigos hexadecimais para formar os números de 0 a 9 no display de 7 segmentos.
