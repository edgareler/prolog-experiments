:- dynamic sobre/3.
:- dynamic livre/2.


/*
 * Cenário 1
 */

% Estado Inicial
sobre(0, a, b).
sobre(0, b, solo).
sobre(0, c, solo).
sobre(0, d, solo).

% Estado Final
sobre(1, a, solo).
sobre(1, b, a).
sobre(1, c, b).
sobre(1, d, c).

% Estado Inicial
livre(0, a).
livre(0, c).
livre(0, d).

% Estado Final
livre(1, d).


/*
 * Cenário 2
 */
/*
% Estado Inicial
sobre(0, g, f).
sobre(0, f, a).
sobre(0, a, solo).
sobre(0, b, solo).

% Estado Final
sobre(1, b, solo).
sobre(1, a, b).
sobre(1, g, a).
sobre(1, f, solo).

% Estado Inicial
livre(0, g).
livre(0, b).

% Estado Final
livre(1, g).
livre(1, f).
*/


/*
 * Cenário 3
 */
% Estado Inicial
/*
sobre(0, a, solo).
sobre(0, j, a).
sobre(0, m, j).
sobre(0, b, m).
sobre(0, d, b).

sobre(0, o, solo).
sobre(0, f, o).
sobre(0, r, f).
sobre(0, w, r).
sobre(0, c, w).
sobre(0, v, c).

sobre(0, n, solo).
sobre(0, z, n).
sobre(0, i, z).
sobre(0, e, i).
sobre(0, k, e).

sobre(0, l, solo).
sobre(0, g, l).
sobre(0, p, g).
sobre(0, s, p).
sobre(0, x, s).

sobre(0, y, solo).
sobre(0, h, y).
sobre(0, q, h).
sobre(0, t, q).

sobre(0, u, solo).

% Estado Final
sobre(1, a, solo).
sobre(1, b, a).
sobre(1, c, b).
sobre(1, d, c).
sobre(1, e, d).
sobre(1, f, e).
sobre(1, g, f).
sobre(1, h, g).
sobre(1, i, h).
sobre(1, j, i).
sobre(1, k, j).
sobre(1, l, k).
sobre(1, m, l).
sobre(1, n, m).
sobre(1, o, n).
sobre(1, p, o).
sobre(1, q, p).
sobre(1, r, q).
sobre(1, s, r).
sobre(1, t, s).
sobre(1, u, t).
sobre(1, v, u).
sobre(1, w, v).
sobre(1, x, w).
sobre(1, y, x).
sobre(1, z, y).

% Estado Inicial
livre(0, d).
livre(0, v).
livre(0, k).
livre(0, x).
livre(0, t).
livre(0, u).

% Estado Final
livre(1, z).
*/
% Verifica se foi atingido objetivo
verificaEstado :- forall(sobre(1, BlocoAcima, BlocoAbaixo), ( sobre(0, BlocoAcima, BlocoAbaixo); false, ! ) ).

% Regra de movimento atômico de objetos
movaPara(X,Y) :- livre(0, X), (Y = solo; livre(0, Y)), sobre(0, X, Y1), write('Movendo bloco '), write(X), write(' para cima de '), writeln(Y), retractall(sobre(0, X, _)), assert(sobre(0, X, Y)), (Y1 = solo, !; assert(livre(0, Y1))).

liberaBloco(X) :- livre(0, X), !;
    sobre(0, Y, X), livre(0, Y), movaPara(Y, solo), !;
    sobre(0, Y, X), liberaBloco(Y).

mostraTorre(B1) :- B1 = solo, writeln(B1), !; sobre(0, B1, BlocoAbaixo), writeln(B1), mostraTorre(BlocoAbaixo).

passoRobo :- verificaEstado, writeln(''), writeln(''), livre(1, B1), mostraTorre(B1), !;
    forall(
        (
            % Itera apenas nos blocos que não estão conforme o Estado Final
            sobre(1, BlocoAcima, BlocoAbaixo), not(sobre(0, BlocoAcima, BlocoAbaixo))
        ),
        (
            % Caso o BlocoAcima tenha de estar no solo, mas ainda não está
            sobre(1, BlocoAcima, solo),
            (
                livre(0, BlocoAcima), movaPara(BlocoAcima, solo)
                ;
                liberaBloco(BlocoAcima)
            ), !;

            livre(0, BlocoAcima), livre(0, BlocoAbaixo), movaPara(BlocoAcima, BlocoAbaixo), !;

            liberaBloco(BlocoAcima)
        )
    ),
    (verificaEstado, writeln(''), writeln(''), livre(1, B1), mostraTorre(B1), !; passoRobo).

