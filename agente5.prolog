/* Custo e Caminho de Menor Custo */

dimensao(5,5).
:- dynamic bicho/2.
alimento(5,4).
obstaculo(2,1).
obstaculo(4,2).
obstaculo(4,3).
obstaculo(4,4).
obstaculo(3,4).
obstaculo(2,4).
lama(4,1).

mudarlivre(10).
mudarlama(30).
mudarlamalivre(20).
mudaralimento(5).

:- dynamic mente/2.

:- dynamic customaximo/1.
customaximo(1000).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

naoobstaculo(X,Y) :- obstaculo(X,Y), assert(mente((X,Y),obstaculo)), !, fail.
naoobstaculo(_,_).

naolama(X,Y) :- lama(X,Y), assert(mente((X,Y),lama)), !, fail.
naolama(_,_).

caminhar(X,Y,H,C) :- alimento(X,Y), customaximo(CAM), C < CAM, retract(customaximo(CAM)), assert(customaximo(C)), assert(bicho(X,Y)), assert(mente((X,Y),alimento)), writeln((X,Y)), !;
                     dentro(X,Y), naoobstaculo(X,Y), naopertence((X,Y),H), assert(bicho(X,Y)), writeln(([(X,Y)|H])),
                     (X1 is X + 1, mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X1,Y), C1 is C + CLV;
                         naolama(X,Y), lama(X1,Y), C1 is C + CLM;
                         lama(X,Y), naolama(X1,Y), C1 is C + CLL;
                         alimento(X1,Y), C1 is C + CAL), retractall(bicho(_,_)), caminhar(X1,Y,[(X,Y)|H],C1);
                      Y1 is Y + 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X,Y1), C1 is C + CLV;
                         naolama(X,Y), lama(X,Y1), C1 is C + CLM;
                         lama(X,Y), naolama(X,Y1), C1 is C + CLL;
                         alimento(X,Y1), C1 is C + CAL), retractall(bicho(_,_)), caminhar(X,Y1,[(X,Y)|H],C1);
                      X2 is X - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X2,Y), C1 is C + CLV;
                         naolama(X,Y), lama(X2,Y), C1 is C + CLM;
                         lama(X,Y), naolama(X2,Y), C1 is C + CLL;
                         alimento(X2,Y), C1 is C + CAL), retractall(bicho(_,_)), caminhar(X2,Y,[(X,Y)|H],C1);
                      Y2 is Y - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X,Y2), C1 is C + CLV;
                         naolama(X,Y), lama(X,Y2), C1 is C + CLM;
                         lama(X,Y), naolama(X,Y2), C1 is C + CLL;
                         alimento(X,Y2), C1 is C + CAL), retractall(bicho(_,_)), caminhar(X,Y2,[(X,Y)|H],C1)).


