/* Alimento e Obstáculo em Posições Conhecidas */

dimensao(5,5).
:- dynamic bicho/2.
alimento(5,4).
obstaculo(3,2).
obstaculo(4,3).
obstaculo(4,4).
obstaculo(5,3).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

naoobstaculo(X,Y) :- obstaculo(X,Y), !, fail.
naoobstaculo(_,_).

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

caminhar(X,Y,H) :- alimento(X,Y), assert(bicho(X,Y)), writeln((X,Y)), !;
                   dentro(X,Y), naoobstaculo(X,Y), naopertence((X,Y),H), assert(bicho(X,Y)), writeln(([(X,Y)|H])), /*writeln(bicho(X,Y)), */
                   (X1 is X + 1, retractall(bicho(_,_)), caminhar(X1,Y,[(X,Y)|H]), !;
                    Y1 is Y + 1, retractall(bicho(_,_)), caminhar(X,Y1,[(X,Y)|H]), !;
                    X2 is X - 1, retractall(bicho(_,_)), caminhar(X2,Y,[(X,Y)|H]), !;
                    Y2 is Y - 1, retractall(bicho(_,_)), caminhar(X,Y2,[(X,Y)|H])).
