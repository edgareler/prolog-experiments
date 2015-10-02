/* Menor Caminho */

dimensao(5,5).
:- dynamic bicho/2.
alimento(5,4).
obstaculo(2,1).
obstaculo(4,2).
obstaculo(4,3).
obstaculo(4,4).
obstaculo(3,4).

:- dynamic mente/2.

:- dynamic menorcaminho/1.
menorcaminho(1000).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

naoobstaculo(X,Y) :- obstaculo(X,Y), assert(mente((X,Y),obstaculo)), !, fail.
naoobstaculo(_,_).

caminhar(X,Y,H,C) :- alimento(X,Y), menorcaminho(CAM), C < CAM, retract(menorcaminho(CAM)), assert(menorcaminho(C)), assert(bicho(X,Y)), assert(mente((X,Y),alimento)), writeln((X,Y)), !;
                     dentro(X,Y), naoobstaculo(X,Y), naopertence((X,Y),H), assert(bicho(X,Y)), writeln(([(X,Y)|H])),
                     (X1 is X + 1, C1 is C + 1, retractall(bicho(_,_)), caminhar(X1,Y,[(X,Y)|H],C1);
                      Y1 is Y + 1, C1 is C + 1, retractall(bicho(_,_)), caminhar(X,Y1,[(X,Y)|H],C1);
                      X2 is X - 1, C1 is C + 1, retractall(bicho(_,_)), caminhar(X2,Y,[(X,Y)|H],C1);
                      Y2 is Y - 1, C1 is C + 1, retractall(bicho(_,_)), caminhar(X,Y2,[(X,Y)|H],C1)).
