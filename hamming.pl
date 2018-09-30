:- initialization(main).

dec2bin(N,L) :-
  dec2bin(N,[],L).
dec2bin(0,L,[0|L]).
dec2bin(1,L,[1|L]).
dec2bin(N,L,R):-
    N > 1,
    X is N mod 2,
    Y is N // 2,
    dec2bin(Y,[X|L],R).

inverte([],Z,Z).
  inverte([H|T],Z,Acc) :-
  inverte(T,Z,[H|Acc]).

xor(A, A, 0).
xor(A, B, 1):-
  A \= B.

parity([A|[]], A).
parity([A|[B|As]], R):-
  xor(A, B, C),
  parity(C, As, R).

parity(R, [], R).
parity(A, [B|Bs], R):-
  xor(A, B, C),
  parity(C, Bs, R).

isPowerOfTwo(1).
isPowerOfTwo(NUM):-
  R is NUM mod 2, R = 0,
  DEC is div(NUM, 2),
  isPowerOfTwo(DEC).

getPowerOfTwo(1, 1). % not really
getPowerOfTwo(NUM, POWER):-
  R is NUM mod 2, R = 0,
  DEC is NUM / 2,
  getPowerOfTwo(DEC, RET),
  POWER is 1 + RET.


checkAtPos(POS, [_|BIN_SEQ], I):-
  IN is I + 1,
  checkAtPos(POS, BIN_SEQ, IN).
checkAtPos(POS, [1|_], POS).

checkAtPos(POS, S_BIN):-
  inverte(S_BIN, R_BIN, []),
  checkAtPos(POS, R_BIN, 1).

getCoverageBitsList(_, _, [], []).
getCoverageBitsList(POS, I, [S|SEQs], [S|LIST]):-
  dec2bin(I, I_BIN),
  checkAtPos(POS, I_BIN),
  NEXT is I + 1,
  getCoverageBitsList(POS, NEXT, SEQs, LIST).
getCoverageBitsList(POS, I, [_|SEQs], LIST):-
  NEXT is I + 1,
  getCoverageBitsList(POS, NEXT, SEQs, LIST).

calcParity([_|Ls], R):-
  parity(Ls, R).


getParityBit(POS, [S|SEQs], R) :-
  getCoverageBitsList(POS, 1, [S|SEQs], LIST),
  calcParity(LIST,R).


generateHammingSeq(SEQ, R):-
  mutate(1, SEQ, MUT),
  generateHammingSeq(1, MUT, MUT, R).

% for POS na seq de bits
generateHammingSeq(_, [], _, []).
generateHammingSeq(NUM, [_|SEQ], ORIG_SEQ, [RES|Rs]):-
  isPowerOfTwo(NUM),
  getPowerOfTwo(NUM, POS),
  getParityBit(POS, ORIG_SEQ, RES),
  NEXT is NUM + 1,
  generateHammingSeq(NEXT, SEQ, ORIG_SEQ, Rs).
generateHammingSeq(NUM, [S|SEQs], ORIG_SEQ, [S|Rs]):-
  NEXT is NUM + 1,
  generateHammingSeq(NEXT, SEQs, ORIG_SEQ, Rs).

mutate(_, [], []).
mutate(NUM, SEQ, [_|Rs]):-
  isPowerOfTwo(NUM),
  NEXT is NUM + 1,
  mutate(NEXT, SEQ, Rs).
mutate(NUM, [S|SEQs], [S|Rs]):-
  NEXT is NUM + 1,
  mutate(NEXT, SEQs, Rs).

toListNum([], []).
toListNum([S|Ss], [R|Rs]):-
  atom_number(S,R), toListNum(Ss,Rs).

toggle(0,1).
toggle(1,0).

changeBitAt(_, [], [], _).
changeBitAt(POS, [S|SEQ], [R|RES], POS):-
  toggle(S,R),
  NEXT is POS + 1,
  changeBitAt(POS,SEQ,RES,NEXT).
changeBitAt(POS, [S|SEQ], [S|RES], I):-
  NEXT is I + 1,
  changeBitAt(POS,SEQ,RES,NEXT).


hamming_distance([],[], []).
hamming_distance([X|S], [X|L], [0|R]) :-
  hamming_distance(S, L, R).
hamming_distance([_|S], [_|L], [1|R]) :-
  hamming_distance(S, L, R).

sumOfParity([], Y, Y, _).
sumOfParity([1|LIST], SUM, Y, I):-
  isPowerOfTwo(I),
  NEXT is I + 1,
  NSUM is Y + I,
  sumOfParity(LIST, SUM, NSUM, NEXT).
sumOfParity([0|LIST], SUM, Y, I):-
  NEXT is I + 1,
  sumOfParity(LIST, SUM, Y, NEXT).

askIfAgain:-
  writeln("Deseja testar outro número? (sim. / nao. )"),
  read(OP),
  (OP = 'sim') -> main ; halt.

main :-
  writeln("Insira um numero em binário protegido por aspas simples e seguido de um ponto (.) ex: '010101'. "),
  read(STRING),
  % Converte para lista de numeros
  string_chars(STRING, SEQUENCIA),
  toListNum(SEQUENCIA, NUMS),
  % Codifica em Hamming
  generateHammingSeq(NUMS, RES),
  % Converte para string
  atomic_list_concat(RES, RESTR),
  write("Número codificado em Hamming: "),
  writeln(RESTR), nl,


  %%% Correção de Erros %%%
  writeln("Digite a posição de um bit para sofrer interferência seguido de um ponto (.) ex: 5. "), read(MUT_POS),
  changeBitAt(MUT_POS, RES, MUTATED_RES,1),
  % Codifica em hamming a seq. de bits incorreta.
  generateHammingSeq(1, MUTATED_RES, MUTATED_RES, MUTATED_RES_CODIFIED),
  % Calcula a distância de hamming para coletar os bits de paridade incoerentes.
  hamming_distance(MUTATED_RES, MUTATED_RES_CODIFIED, HAM_DIST),
  % Matemágica
  write("Bits de paridade alterados: "), writeln(HAM_DIST),
  sumOfParity(HAM_DIST, SUM, 0, 1),
  write("Posição do bit alterado: "), writeln(SUM), nl,

  askIfAgain.
