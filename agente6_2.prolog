/* Custo e Caminho de Menor Custo */
/* Implementação do Algoritmo Branch and Bound */

dimensao(18,6).
:- dynamic bicho/2.

alimento(17,3).

obstaculo(3,2).
obstaculo(3,3).
obstaculo(3,4).
obstaculo(3,5).
obstaculo(4,2).
obstaculo(4,5).
obstaculo(5,2).
obstaculo(5,5).
obstaculo(6,2).
obstaculo(6,4).
obstaculo(6,5).
obstaculo(7,2).
obstaculo(8,2).
obstaculo(9,2).
obstaculo(9,3).
obstaculo(9,4).
obstaculo(9,5).
obstaculo(9,6).
obstaculo(10,5).
obstaculo(10,6).
obstaculo(11,1).
obstaculo(11,2).
obstaculo(11,3).
obstaculo(11,5).
obstaculo(11,6).
obstaculo(12,1).
obstaculo(12,5).
obstaculo(12,6).
obstaculo(13,1).
obstaculo(13,3).
obstaculo(13,4).
obstaculo(13,5).
obstaculo(13,6).
obstaculo(14,1).
obstaculo(15,1).
obstaculo(16,1).
obstaculo(16,2).
obstaculo(16,3).
obstaculo(16,4).
obstaculo(16,5).

lama(-1,-1).

mudarlivre(10).
mudarlama(30).
mudarlamalivre(20).
mudaralimento(5).

:- dynamic mente/2.

:- dynamic customaximo/1.
customaximo(1000).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

adiciona(X,L,[X|L]).

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

naoobstaculo(X,Y) :- obstaculo(X,Y), assert(mente((X,Y),obstaculo)), !, fail.
naoobstaculo(_,_).

naolama(X,Y) :- lama(X,Y), assert(mente((X,Y),lama)), !, fail.
naolama(_,_).

item(X,Y,H) :- alimento(X,Y), write('A'), !;
               lama(X,Y), write('L'), !;
               obstaculo(X,Y), write('X'), !;
               pertence((X,Y),H), write('*'), !;
               write(' ').

mapa(X,Y,H) :- write('['), item(X,Y,H), write(']'), 
            (dimensao(X,Y), !;
            (dimensao(X,_), X1 is 1, Y1 is Y + 1, writeln(''), !; X1 is X + 1, Y1 is Y), mapa(X1,Y1,H)).

/*
 * Deve começar em 5,4
 * caminhar(5,4,[],0)
 */
caminhar(X,Y,H,C) :- alimento(X,Y), customaximo(CAM), C < CAM, retract(customaximo(CAM)), assert(customaximo(C)), assert(bicho(X,Y)), assert(mente((X,Y),alimento)), write('Custo: '), write(C), write(', Caminho: '), adiciona((X,Y),H,H1), writeln(H1), mapa(1,1,H);
                     dentro(X,Y), naoobstaculo(X,Y), naopertence((X,Y),H), assert(bicho(X,Y)), % writeln(([(X,Y)|H])),
                     (X1 is X + 1, mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X1,Y), C1 is C + CLV;
                         naolama(X,Y), lama(X1,Y), C1 is C + CLM;
                         lama(X,Y), naolama(X1,Y), C1 is C + CLL;
                         alimento(X1,Y), C1 is C + CAL), retractall(bicho(_,_)), customaximo(CMAX), C1 < CMAX, caminhar(X1,Y,[(X,Y)|H],C1);
                      Y1 is Y + 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X,Y1), C1 is C + CLV;
                         naolama(X,Y), lama(X,Y1), C1 is C + CLM;
                         lama(X,Y), naolama(X,Y1), C1 is C + CLL;
                         alimento(X,Y1), C1 is C + CAL), retractall(bicho(_,_)), customaximo(CMAX), C1 < CMAX, caminhar(X,Y1,[(X,Y)|H],C1);
                      X2 is X - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X2,Y), C1 is C + CLV;
                         naolama(X,Y), lama(X2,Y), C1 is C + CLM;
                         lama(X,Y), naolama(X2,Y), C1 is C + CLL;
                         alimento(X2,Y), C1 is C + CAL), retractall(bicho(_,_)), customaximo(CMAX), C1 < CMAX, caminhar(X2,Y,[(X,Y)|H],C1);
                      Y2 is Y - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                        (naolama(X,Y), naolama(X,Y2), C1 is C + CLV;
                         naolama(X,Y), lama(X,Y2), C1 is C + CLM;
                         lama(X,Y), naolama(X,Y2), C1 is C + CLL;
                         alimento(X,Y2), C1 is C + CAL), retractall(bicho(_,_)), customaximo(CMAX), C1 < CMAX, caminhar(X,Y2,[(X,Y)|H],C1)).


