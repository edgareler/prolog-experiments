/* Custo e Caminho de Menor Custo */
/* Implementação do Algoritmo Branch and Bound */
/* Correção */

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

adiciona(X,L,[X|L]).

removePrimeiro([_|L],L).

listaVazia([]).

insereOrdenado(X,[C|R],[C|LR]) :- X > C, insereOrdenado(X,R,LR).
insereOrdenado(X,[C|R],[X,C|R]) :- X =< C.
insereOrdenado(X,[],[X]).

insereOrdenadoComposto([X|RX],[[C|R1]|R],[[C|R1]|LR]) :- X > C, insereOrdenadoComposto([X|RX],R,LR).
insereOrdenadoComposto([X|RX],[[C|R1]|R],[[X|RX]|[[C|R1]|R]]) :- X =< C.
insereOrdenadoComposto(X,[],[X]).

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(_,_).

naoobstaculo(X,Y) :- obstaculo(X,Y), assert(mente((X,Y),obstaculo)), !, fail.
naoobstaculo(_,_).

naolama(X,Y) :- lama(X,Y), assert(mente((X,Y),lama)), !, fail.
naolama(_,_).

:- dynamic caminhosPossiveis/1.
caminhosPossiveis([]).

:- dynamic melhorCaminho/1.
melhorCaminho([]).

item(X,Y,H) :- alimento(X,Y), write('A'), !;
               lama(X,Y), write('L'), !;
               obstaculo(X,Y), write('X'), !;
               pertence((X,Y),H), write('*'), !;
               write(' ').

mapa(X,Y,H) :- write('['), item(X,Y,H), write(']'), 
            (dimensao(X,Y), !;
            (dimensao(X,_), X1 is 1, Y1 is Y + 1, writeln(''), !; X1 is X + 1, Y1 is Y), mapa(X1,Y1,H)).

custo(X,Y,X1,Y1,C) :-
    mudarlivre(CLV), mudarlama(CLM), mudarlamalivre(CLL), mudaralimento(CAL),
%    naolama(X,Y), naolama(X1,Y1), C is CLV;
    (naolama(X,Y), lama(X1,Y1), C is CLM;
    lama(X,Y), naolama(X1,Y1), C is CLL;
    alimento(X1,Y1), C is CAL;
    C is CLV).

verificaNo(X,Y,X1,Y1,H,CANT) :- 
    dentro(X1,Y1), write(' | Dentro'), naoobstaculo(X1,Y1), write(' | Não Obstáculo'), naopertence((X1,Y1),H), write(' | Não Visitado'),  custo(X,Y,X1,Y1,C1), write(' | Custo: '), write(C1),
    (caminhosPossiveis(RTST), length(RTST,RLEN), RLEN = 0,
        write(' - Lista vazia - '), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis([[C1,[(X1,Y1)|H]]|[]])), write(' | Lista iniciada.')
    ;
        write(' - Lista não vazia - '), C1R is C1 + CANT, write(' | Custo Total: '), write(C1), customaximo(CMAX),
        %(
        C1R < CMAX,
            caminhosPossiveis(L), insereOrdenadoComposto([C1R,[(X1,Y1)|H]], L, LR), write(' | Lista: '), write(LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR)), write(' | Novo caminho adicionado. | Lista: '), writeln(LR)
        %;
            % caminhosPossiveis(L1), removePrimeiro(L1,LX), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LX)), write(' | Caminho removido. | Lista: '), writeln(LX)
            
        %)
    ).


caminhar(X,Y,H) :- sleep(1),    
    write('Verificar nó '), writeln((X,Y)), writeln(''),

    alimento(X,Y), caminhosPossiveis([[C|_]|_]), customaximo(CAM), C < CAM, retract(customaximo(CAM)), assert(customaximo(C)), assert(bicho(X,Y)), assert(mente((X,Y),alimento)),
    retractall(melhorCaminho(_)), assert(melhorCaminho([(X,Y)|H])),
    writeln(''), writeln('###################'), write('Alimento Encontrado! '), write((X,Y)), write(' Custo: '), write(C), write(', Caminho: '), adiciona((X,Y),H,H1), writeln(H1), mapa(1,1,H), writeln(''), writeln('###################'), writeln(''),     
    caminhosPossiveis(LANT), removePrimeiro(LANT,LNEW), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LNEW)),
    caminhosPossiveis([[_,[(XN,YN)|HN]]|_]), writeln(''), write('Próximo nó: '), writeln((XN,YN)), caminhar(XN,YN,HN),
    fail, writeln(''), writeln(''), write('Custo: '), customaximo(CM), writeln(CM), writeln('Melhor caminho: '), caminhosPossiveis(CP), writeln(CP), writeln('');% ; true % fail;

    % dentro(X,Y), naoobstaculo(X,Y), naopertence((X,Y),H), assert(bicho(X,Y)), % writeln(([(X,Y)|H])),
    
    % Só explora o nó de menor custo
    % caminhosPossiveis([CR|RC]|R), 

    (
        caminhosPossiveis(RTST), length(RTST,RLEN), RLEN = 0, CANT = 0, writeln('** Lista Vazia **')
    ;
        caminhosPossiveis([[CANT|_]|_]), caminhosPossiveis(LTMP), removePrimeiro(LTMP,LTMP1), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LTMP1)), writeln(''), write('Primeiro item removido. Custo: '), write(CANT), write('; Lista: '), writeln(LTMP1)
    ),

    writeln('Verificando caminhos possíveis...'),

    (
        Y4 is Y - 1, X4 is X, writeln(''), write((X4,Y4)), verificaNo(X,Y,X4,Y4,H,CANT)
        ; write(' | Inválido (4)'), true
    ),

    (
        X3 is X - 1, Y3 is Y, writeln(''), write((X3,Y3)), verificaNo(X,Y,X3,Y3,H,CANT)
        ; write(' | Inválido (3)'), true
    ),

    (
        Y2 is Y + 1, X2 is X, writeln(''), write((X2,Y2)), verificaNo(X,Y,X2,Y2,H,CANT)
        ; write(' | Inválido (2)'), true
    ),

    (
        X1 is X + 1, Y1 is Y, writeln(''), write((X1,Y1)), verificaNo(X,Y,X1,Y1,H,CANT)
        ; write(' | Inválido (1)'), true
    ),

    caminhosPossiveis([[_,[(XP,YP)|_]]|_]), writeln(''), write('Próximo nó: '), writeln((XP,YP)), caminhar(XP,YP,[(XP,YP)|H]).


/*
    (
        X1 is X + 1, Y1 is Y, dentro(X1,Y1), naoobstaculo(X1,Y1), naopertence((X1,Y1),H), custo(X,Y,X1,Y1,C1),
        caminhosPossiveis([CR|RC]|R), C1R is C1 + CR, insereOrdenadoComposto([C1R|[(X1,Y1)|H]], R, LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR))
        ; true
    ), 

    (
        Y1 is Y + 1, X1 is X, dentro(X1,Y1), naoobstaculo(X1,Y1), naopertence((X1,Y1),H), custo(X,Y,X1,Y1,C1),
        caminhosPossiveis([CR|RC]|R), C1R is C1 + CR, insereOrdenadoComposto([C1R|[(X1,Y1)|H]], R, LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR))
        ; true
    ), 

    (
        X1 is X + 1, Y1 is Y, dentro(X1,Y1), naoobstaculo(X1,Y1), naopertence((X1,Y1),H), custo(X,Y,X1,Y1,C1),
        caminhosPossiveis([CR|RC]|R), C1R is C1 + CR, insereOrdenadoComposto([C1R|[(X1,Y1)|H]], R, LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR))
        ; true
    ), 

    (
        X1 is X + 1, Y1 is Y, dentro(X1,Y1), naoobstaculo(X1,Y1), naopertence((X1,Y1),H), custo(X,Y,X1,Y1,C1),
        caminhosPossiveis([CR|RC]|R), C1R is C1 + CR, insereOrdenadoComposto([C1R|[(X1,Y1)|H]], R, LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR))
        ; true
    ),
*/

/*
                     (X1 is X + 1, 
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
*/

