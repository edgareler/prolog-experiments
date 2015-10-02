/* Agentes Colaborativos */

dimensao(5,5).
:- dynamic base/4.

/*
 * Base 0: Memória da Natureza
 * Base 1: Memória do Agente 1
 * Base 2: Memória do Agente 2
 * Base 3: Memória Compartilhada
 */
base(0,1,1,agente).
base(0,1,5,agente).
base(0,5,4,alimento).
base(0,2,1,obstaculo).
base(0,4,2,obstaculo).
base(0,4,3,obstaculo).
base(0,4,4,obstaculo).
base(0,3,4,obstaculo).
base(0,2,4,obstaculo).
base(0,2,4,lama).
base(1,1,1,agente).
base(2,1,5,agente).
base(3,1,1,agente).
base(3,1,5,agente).

mudarlivre(10).
mudarlama(30).
mudarlamalivre(20).
mudaralimento(5).

:- dynamic customaximo/1.
customaximo(1000).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

naoobstaculo(A,X,Y) :- base(0,X,Y,obstaculo), assert(base(A,X,Y,obstaculo)), assert(base(3,X,Y,obstaculo)), !, fail.
naoobstaculo(_,_,_).

naolama(A,X,Y) :- base(0,X,Y,lama), assert(base(A,X,Y,lama)), assert(base(3,X,Y,lama)), !, fail.
naolama(_,_,_).

caminhar(A,X,Y,H,C) :- base(0,X,Y,alimento), customaximo(CMAX), C < CAM, retract(customaximo(CAM)), assert(customaximo(C)),
                        retractall(base(A,_,_,agente)), assert(base(A,X,Y,agente)), assert(base(A,X,Y,alimento)), assert(base(3,X,Y,alimento)), writeln((X,Y)), !;

                         dentro(X,Y), naoobstaculo(A,X,Y), naopertence((X,Y),H), assert(base(A,X,Y,agente)), writeln(([(X,Y)|H])),

                         (X1 is X + 1, mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                            (naolama(A,X,Y), naolama(A,X1,Y), C1 is C + CLV;
                             naolama(A,X,Y), base(0,X1,Y,lama), C1 is C + CLM;
                             base(0,X,Y,lama), naolama(X1,Y), C1 is C + CLL;
                             alimento(X1,Y), C1 is C + CAL), retractall(base(A,_,_,agente)), customaximo(CMAX), C1 < CMAX, caminhar(A,X1,Y,[(X,Y)|H],C1);

                          Y1 is Y + 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                            (naolama(A,X,Y), naolama(A,X,Y1), C1 is C + CLV;
                             naolama(A,X,Y), base(0,X,Y1,lama), C1 is C + CLM;
                             base(0,X,Y,lama), naolama(A,X,Y1), C1 is C + CLL;
                             alimento(X,Y1), C1 is C + CAL), retractall(base(A,_,_,agente)), customaximo(CMAX), C1 < CMAX, caminhar(A,X,Y1,[(X,Y)|H],C1);

                          X2 is X - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                            (naolama(A,X,Y), naolama(A,X2,Y), C1 is C + CLV;
                             naolama(A,X,Y), base(0,X2,Y,lama), C1 is C + CLM;
                             base(0,X,Y,lama), naolama(X2,Y), C1 is C + CLL;
                             alimento(X2,Y), C1 is C + CAL), retractall(base(A,_,_,agente)), customaximo(CMAX), C1 < CMAX, caminhar(A,X2,Y,[(X,Y)|H],C1);

                          Y2 is Y - 1,  mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
                            (naolama(A,X,Y), naolama(A,X,Y2), C1 is C + CLV;
                             naolama(A,X,Y), base(0,X,Y2,lama), C1 is C + CLM;
                             base(0,X,Y,lama), naolama(X,Y2), C1 is C + CLL;
                             alimento(X,Y2), C1 is C + CAL), retractall(base(A,_,_,agente)), customaximo(CMAX), C1 < CMAX, caminhar(A,X,Y2,[(X,Y)|H],C1)).


