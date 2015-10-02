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

%lama(1,4).
%lama(2,5).
%lama(4,5).

noMelhorCaminho(1,5).

:- dynamic custoNoMelhorCaminho/1.
custoNoMelhorCaminho(1000).

:- dynamic melhorCaminhoNo/1.
melhorCaminhoNo([]).

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

iniciaLista(X,[X]).

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
    (naolama(X,Y), lama(X1,Y1), C is CLM;
    lama(X,Y), naolama(X1,Y1), C is CLL;
    alimento(X1,Y1), C is CAL;
    C is CLV).

verificaNo(X,Y,X1,Y1,H,CANT) :- 
    dentro(X1,Y1), write(' | CANT: '), write(CANT), write(' | Dentro'), naoobstaculo(X1,Y1), write(' | Não Obstáculo'), naopertence((X1,Y1),H), write(' | Não Visitado'),  custo(X,Y,X1,Y1,C1), write(' | Custo: '), write(C1),
    (caminhosPossiveis(RTST), length(RTST,RLEN), RLEN = 0,
        write(' - Lista vazia - '), retractall(caminhosPossiveis(_)), C1L is C1 + CANT, assert(caminhosPossiveis([[C1L,[(X1,Y1)|H]]|[]])), write(' | Lista iniciada.')
    ;
        write(' - Lista não vazia - '), C1R is C1 + CANT, write(' | Custo Total: '), write(C1R), customaximo(CMAX),
        C1R < CMAX,
            caminhosPossiveis(L), insereOrdenadoComposto([C1R,[(X1,Y1)|H]], L, LR), write(' | Lista: '), write(LR), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LR)), write(' | Novo caminho adicionado. | Lista: '), writeln(LR)

    ).


caminhar(X,Y,H) :- % sleep(1),

    write('Verificar nó '), writeln((X,Y)), writeln(''),
    (
    /*
        noMelhorCaminho(X,Y), caminhosPossiveis([[CN|_]|_]), custoNoMelhorCaminho(CNM), CN < CNM, retract(custoNoMelhorCaminho(CNM)), assert(custoNoMelhorCaminho(CN)), assert(bicho(X,Y)), assert(mente((X,Y),melhorCaminho)),
        retractall(melhorCaminhoNo(_)), assert(melhorCaminhoNo([(X,Y)|H])),
    */
        alimento(X,Y), writeln('** É alimento. **'), caminhosPossiveis([[C|_]|_]), write('Custo atual: '), writeln(C),
        customaximo(CAM), write('Custo máximo: '), writeln(CAM),
        (
            C < CAM, writeln('-- Custo Inferior. --'), retract(customaximo(CAM)), assert(customaximo(C)), assert(bicho(X,Y)), assert(mente((X,Y),alimento)),
            retractall(melhorCaminho(_)), assert(melhorCaminho(H)),
            writeln(''), writeln('###################'), write('Alimento Encontrado! '), write((X,Y)), write(' Custo: '), write(C), write(', Caminho: '), writeln(H), mapa(1,1,H), writeln(''), writeln('###################'), writeln('')
            ;
            writeln('++ Custo Superior. ++'), true
        ),     
        caminhosPossiveis(LANT), writeln(''), writeln(''), writeln(LANT), writeln(''), writeln(''),
        removePrimeiro(LANT,LNEW), writeln(LNEW), writeln(''), writeln(''), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LNEW)),
        caminhosPossiveis(R0), length(R0,R0LEN),
        (R0LEN > 0, caminhosPossiveis([[_,[(XN,YN)|HN]]|_]), writeln(''), write('Próximo nó: '), writeln((XN,YN)), caminhar(XN,YN,HN)
        ;
        writeln(''), writeln(''), writeln('Melhor caminho: '), melhorCaminho(CP), writeln(CP), writeln(''), write('Custo: '), customaximo(CM), writeln(CM), writeln(''), writeln(''), !), ! %, 

        % fail
       % fail
    )
    ; %, % ; true % fail;

    (
        (alimento(X,Y), writeln('Não deveria ter passado!!!'), writeln('H: '), writeln(H), writeln('C: '), caminhosPossiveis(LC), writeln(LC), sleep(30); true),       

        (
            caminhosPossiveis(RTST), length(RTST,RLEN), RLEN = 0, CANT = 0, writeln('** Lista Vazia **') %, iniciaLista((X,Y),H) % H is [(X,Y)]
        ;
            writeln('** Lista Não Vazia **'), caminhosPossiveis([[CANT|_]|_]), caminhosPossiveis(LTMP), writeln('--'), writeln(''), writeln(LTMP), writeln(''), writeln('--'), removePrimeiro(LTMP,LTMP1), retractall(caminhosPossiveis(_)), assert(caminhosPossiveis(LTMP1)), writeln(''), write('Primeiro item removido. Custo: '), write(CANT), write('; Lista: '), writeln(LTMP1)
        ),

        writeln('Verificando caminhos possíveis...'),
        writeln(''),
        writeln('Histórico: '),
        writeln(H),
        writeln(''),

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

        caminhosPossiveis([[_,[(XP,YP)|HP]]|_]), writeln(''), write('Próximo nó: '), writeln((XP,YP)), caminhar(XP,YP,[(XP,YP)|HP])
    ). %,

iniciar :- tell('out.log'), caminhar(1,1,[(1,1)]), told.
