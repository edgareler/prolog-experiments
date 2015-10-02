/* Custo e Caminho de Menor Custo */
/* Implementação do Algoritmo Branch and Bound */

dimensao(32,19).
:- dynamic bicho/2.

alimento(30,15).

obstaculo(1,13).
obstaculo(1,14).
obstaculo(1,15).
obstaculo(1,16).
obstaculo(1,17).
obstaculo(2,13).
obstaculo(2,15).
obstaculo(2,17).
obstaculo(3,13).
obstaculo(3,15).
obstaculo(4,13).
obstaculo(4,15).
obstaculo(4,17).
obstaculo(5,15).
obstaculo(5,17).
obstaculo(6,13).
obstaculo(6,15).
obstaculo(7,1).
obstaculo(7,2).
obstaculo(7,3).
obstaculo(7,4).
obstaculo(7,5).
obstaculo(7,13).
obstaculo(7,15).
obstaculo(7,17).
obstaculo(8,1).
obstaculo(8,5).
obstaculo(8,7).
obstaculo(8,8).
obstaculo(8,9).
obstaculo(8,10).
obstaculo(8,11).
obstaculo(8,13).
obstaculo(8,15).
obstaculo(8,17).
obstaculo(8,18).
obstaculo(8,19).
obstaculo(9,1).
obstaculo(9,3).
obstaculo(9,5).
obstaculo(9,7).
obstaculo(9,11).
obstaculo(9,13).
obstaculo(9,15).
obstaculo(9,17).
obstaculo(10,1).
obstaculo(10,3).
obstaculo(10,5).
obstaculo(10,7).
obstaculo(10,8).
obstaculo(10,9).
obstaculo(10,11).
obstaculo(10,13).
obstaculo(10,15).
obstaculo(11,1).
obstaculo(11,3).
obstaculo(11,5).
obstaculo(11,9).
obstaculo(11,11).
obstaculo(11,13).
obstaculo(11,15).
obstaculo(11,17).
obstaculo(12,1).
obstaculo(12,3).
obstaculo(12,9).
obstaculo(12,11).
obstaculo(12,13).
obstaculo(12,15).
obstaculo(12,17).
obstaculo(13,1).
obstaculo(13,3).
obstaculo(13,4).
obstaculo(13,5).
obstaculo(13,6).
obstaculo(13,7).
obstaculo(13,8).
obstaculo(13,9).
obstaculo(13,11).
obstaculo(13,13).
obstaculo(13,15).
obstaculo(13,17).
obstaculo(14,1).
obstaculo(14,11).
obstaculo(14,13).
obstaculo(14,15).
obstaculo(14,17).
obstaculo(15,1).
obstaculo(15,8).
obstaculo(15,11).
obstaculo(15,15).
obstaculo(15,17).
obstaculo(16,1).
obstaculo(16,4).
obstaculo(16,8).
obstaculo(16,9).
obstaculo(16,10).
obstaculo(16,11).
obstaculo(16,12).
obstaculo(16,13).
obstaculo(16,14).
obstaculo(16,15).
obstaculo(16,16).
obstaculo(16,17).
obstaculo(17,1).
obstaculo(17,4).

% Caminho cercado
obstaculo(17,7).

obstaculo(18,1).
obstaculo(18,2).
obstaculo(18,3).
obstaculo(18,4).
obstaculo(18,5).
obstaculo(18,6).
obstaculo(19,6).
obstaculo(19,11).
obstaculo(19,12).
obstaculo(19,13).
obstaculo(19,14).
obstaculo(19,15).
obstaculo(19,16).
obstaculo(20,6).
obstaculo(20,11).
obstaculo(20,12).
obstaculo(20,13).
obstaculo(20,14).
obstaculo(20,15).
obstaculo(20,16).
obstaculo(21,6).
obstaculo(21,11).
obstaculo(21,12).
obstaculo(21,13).
obstaculo(21,14).
obstaculo(21,15).
obstaculo(21,16).
obstaculo(22,6).
obstaculo(22,11).
obstaculo(22,12).
obstaculo(22,13).
obstaculo(22,14).
obstaculo(22,15).
obstaculo(22,16).
obstaculo(23,11).
obstaculo(23,12).
obstaculo(23,13).
obstaculo(23,14).
obstaculo(23,15).
obstaculo(23,16).
obstaculo(26,2).
obstaculo(26,3).
obstaculo(26,4).
obstaculo(27,4).
obstaculo(27,12).
obstaculo(27,13).
obstaculo(27,14).
obstaculo(27,15).
obstaculo(27,16).
obstaculo(27,17).
obstaculo(28,1).
obstaculo(28,2).
obstaculo(28,4).
obstaculo(28,12).
obstaculo(28,17).
obstaculo(29,4).
obstaculo(29,12).
obstaculo(29,17).
obstaculo(30,2).
obstaculo(30,3).
obstaculo(30,4).
obstaculo(30,5).
obstaculo(30,6).
obstaculo(30,7).
obstaculo(30,8).
obstaculo(30,9).
obstaculo(30,10).
obstaculo(30,11).
obstaculo(30,12).
obstaculo(30,17).
obstaculo(31,17).



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


