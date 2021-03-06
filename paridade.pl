:- initialization(main).

toListNum([], []).
toListNum([S|Ss], [R|Rs]):-
  atom_number(S,R), toListNum(Ss,Rs).

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

askIfAgain:-
  writeln("Desesja testar outro número? (sim. / nao. )"),
  read(OP),
  (OP = 'sim') -> main ; halt.

main :-
  writeln("Insira um numero em binário seguido de um ponto (.):"),
  read(STRING),
  % Converte para lista
  string_chars(STRING, SEQUENCIA),
  toListNum(SEQUENCIA, NUMS),
  parity(NUMS, RES),
  writeln(RES),
  askIfAgain.
