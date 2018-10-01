# Hamming Code Implementation

The codes in this reporitory consists in:

1 - Parity check in PROLOG.

2 - Hamming code implementation in Prolog language.

The code consists of detecting and correcting errors in a sequence of bits.
If more error-correcting bits are included with a message, and if those bits can be arranged such that different incorrect bits produce different error results, then bad bits could be identified. In a seven-bit message, there are seven possible single bit errors, so three error control bits could potentially specify not only that an error occurred but also which bit caused the error.
*From Wikipedia*

> Developed for the discipline "Organization and Architecture of Computers", of the course "Computer Science" at the Federal University of Campina Grande. 2018

## Execução

Para executar o código basta ter o [SWI Prolog](http://www.swi-prolog.org/) e executar o seguinte comando:

    $ swipl [arquivo].pl

### Exemplo de execução (paridade.pl)

    Insira um numero em binário seguido de um ponto (.):
    |: 010101.
    1
    Desesja testar outro número? (sim. / nao. )
    |: sim.
    Insira um numero em binário seguido de um ponto (.):
    |: 11100011.
    1
    Desesja testar outro número? (sim. / nao. )
    |: sim.
    Insira um numero em binário seguido de um ponto (.):
    |: 11111111.
    0
    Desesja testar outro número? (sim. / nao. )
    |: nao.


### Exemplo de execução (hamming.pl)

    Insira um numero em binário protegido por aspas simples e seguido de um ponto (.) ex: '010101'. 
    |: '01010101'.
    Número codificado em Hamming: 000110100101

    Digite a posição de um bit para sofrer interferência seguido de um ponto (.) ex: 5. 
    |: 6.
    Bits de paridade alterados: [0,1,0,1,0,0,0,0,0,0,0,0]
    Posição do bit alterado: 6

    Deseja testar outro número? (sim. / nao. )
    |: nao.
