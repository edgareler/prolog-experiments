
/*
 * mapa(x,y,p)
 * x,y: posição
 * p: peso
 */
% :- dynamic mapa/3.
mapa(1,1,7).
mapa(1,2,4).
mapa(1,3,7).
mapa(2,1,4).
mapa(2,2,10).
mapa(2,3,4).
mapa(3,1,7).
mapa(3,2,4).
mapa(3,3,7).

/*
insereDecrescenteComposto([X|RX],[[C|R1]|R],[[C|R1]|LR]) :- write(X), write(' < '), writeln(C), X < C, writeln('X < C'), insereDecrescenteComposto([X|RX],R,LR).
insereDecrescenteComposto([X|RX],[[C|R1]|R],[[X|RX]|[[C|R1]|R]]) :- write(X), write(' >= '), writeln(C),X >= C, writeln('X >= C').
insereDecrescenteComposto(X,[],[X]).

insert(X, [], [X]).
insert(X, [Y|Rest], [X,Y|Rest]) :- X >= Y, !.
insert(X, [Y|Rest0], [Y|Rest]) :- insert(X, Rest0, Rest).
*/

insertDesc(X, [], [X]).
insertDesc([X|RX], [[Y|RY]|Rest], [[X|RX],[Y|RY]|Rest]) :- X >= Y, !.
insertDesc([X|RX], [[Y|RY]|Rest0], [[Y|RY]|Rest]) :- insertDesc([X|RX], Rest0, Rest).

insertAsc(X, [], [X]).
insertAsc([X|RX], [[Y|RY]|Rest], [[X|RX],[Y|RY]|Rest]) :- X =< Y, !.
insertAsc([X|RX], [[Y|RY]|Rest0], [[Y|RY]|Rest]) :- insertDesc([X|RX], Rest0, Rest).

/*
 * jogador(j)
 */
jogador(1).
jogador(2).

/*
 * jogada(j,x,y)
 * j: jogador
 * x,y: posição
 */
:- dynamic jogada/3.

/*
 * contX(j,n)
 * j: jogador
 * n: numero
 */
:- dynamic contX/2.
contX(1,0).
contX(2,0).

/*
 * contY(j,n)
 * j: jogador
 * n: numero
 */
:- dynamic contY/2.
contY(1,0).
contY(2,0).

/*
 * contD(j,n)
 * j: jogador
 * n: numero
 */
:- dynamic contD1/2.
contD1(1,0).
contD1(2,0).
:- dynamic contD2/2.
contD2(1,0).
contD2(2,0).

:- dynamic vitoria/1.
vitoria(0).

% verificaVitoria(J1) :- forall(jogador(J), (contX(J,CX), CX >= 3, J1 is J, !; contY(J,CY), CY >= 3, J1 is J, !; contD(J,CD), CD >= 3, J1 is J, !; false) ). %, writeln(J1), ((J1 = 1, !; J1 = 2), JR is J1).

verificaVitoria(J1) :-
    forall((jogador(J), vitoria(V), V = 0), (
        forall((jogada(J,X,Y), vitoria(V), V = 0), (
            (forall((jogada(J,X,_), vitoria(V), V = 0), (
                contX(J,CX), retractall(contX(J,_)), CX1 is CX + 1, assert(contX(J,CX1))
            )), contX(J,QX), write(QX), writeln(' contX'), retractall(contX(J,_)), assert(contX(J,0)), QX = 3, writeln('contX atingiu a meta!'), retractall(vitoria(_)), assert(vitoria(J)), !), !;
            
            (forall((jogada(J,_,Y), vitoria(V), V = 0), (
                contY(J,CY), retractall(contY(J,_)), CY1 is CY + 1, assert(contY(J,CY1))
            )), contY(J,QY), write(QY), writeln(' contY'), retractall(contY(J,_)), assert(contY(J,0)), QY = 3, writeln('contY atingiu a meta!'), retractall(vitoria(_)), assert(vitoria(J)), !), !;
            
            (X = Y, contD1(J,CD1), retractall(contD1(J,_)), CD11 is CD1 + 1, assert(contD1(J,CD11))), !;
            
            ((X = 1, Y = 3, !; X = 3, Y = 1, !; X = 2, Y = 2), contD2(J,CD2), retractall(contD2(J,_)), CD21 is CD2 + 1, assert(contD2(J,CD21))), !

        )),

        (contD1(J,QD1), write(QD1), writeln(' contD1'), retractall(contD1(J,_)), assert(contD1(J,0)), QD1 = 3, writeln('contD1 atingiu a meta!'), retractall(vitoria(_)), assert(vitoria(J)), !),

        (contD2(J,QD2), write(QD2), writeln(' contD2'), retractall(contD2(J,_)), assert(contD2(J,0)), QD2 = 3, writeln('contD2 atingiu a meta!'), retractall(vitoria(_)), assert(vitoria(J)), !)
        
    )), vitoria(J1).

/*
 * melhorJogada(x,y,p)
 */
:- dynamic melhorJogada/3.

/*
 * pesosDinamicos([p,(x,y)])
 */
:- dynamic pesosDinamicos/1.

avaliacaoEstatica(J) :-
    % (J = 1, O is 2; O is 1),

    %writeln('-6'), 

    retractall(pesosDinamicos(_)), assert(pesosDinamicos([])),

    %writeln('-5'), 

    % (J = 1, O is 2, !; O is 1),

    J1 is 1,

    forall(mapa(X,Y,P),
        (
            (
                not(jogada(_,X,Y)),

                %writeln('-4'), 

                /*
                 * Avaliação dos Pesos Combinados
                 */

                % Verifica se ponto configura Ataque Duplo
                (
                    (
                        jogada(J1,X,_), jogada(J1,_,Y), !;
                        not(X = 2), jogada(J1,X,_), jogada(J1,2,2), !;
                        not(Y = 2), jogada(J1,_,Y), jogada(J1,2,2)
                    ), AD is 1, write((X,Y)), writeln(' - Ataque Duplo!'), !;
                    AD is 0
                ),

                %writeln('-3'), 

                % Verifica se ponto configura Ameaça
                (
                    (
                        jogada(J1,X,_), !;
                        jogada(J1,_,Y), !;
                        jogada(J1,2,2)
                    ), AM is 1, write((X,Y)), writeln(' - Ameaca!'), !;
                    AM is 0
                ),

                %writeln('-2'), 
                
                % Peso da Movimentação já atribuída no primeiro termo do forall
                
                % Função de Avaliação Estática
                % PR is ((P * 5) + (AD * 10) + (AM * 7)),
                PR is ((P * 5) + (AD * 30) + (AM * 20)),

                pesosDinamicos(L), % length(L,LLEN),
                (
                    % LLEN = 0, writeln('Vazia'), /*LR is [PR,(X,Y)],*/ retractall(pesosDinamicos(_)), assert(pesosDinamicos([PR,(X,Y)])), !;
                    % writeln('Não Vazia'),
                    
                    %writeln('-1'), 
                    J = 1, insertDesc([PR,(X,Y)], L, L1), /*writeln('-0.5'), writeln(L),*/ retractall(pesosDinamicos(_)), assert(pesosDinamicos(L1)), !; %,  writeln('-0.25')
                    J = 2, PR2 is PR * (-1), insertAsc([PR2,(X,Y)], L, L1), retractall(pesosDinamicos(_)), assert(pesosDinamicos(L1))
                )
            ), !; true
        )
    ),

    %writeln(''),

    %writeln('0'), 

    % Após avaliar todo o mapa disponível, captura a melhor jogada
    pesosDinamicos([[_,(MelhorX,MelhorY)]|_]),
    %writeln('1'), 
    % Atualiza Contadores
    % (jogada(J,MelhorX,_), contX(J,N1), N11 is N1 + 1, retractall(contX(J,_)), assert(contX(J,N11)), !; true),
    %writeln('2'), 
    % (jogada(J,_,MelhorY), contY(J,N2), N22 is N2 + 1, retractall(contX(J,_)), assert(contY(J,N22)), !; true),
    %writeln('3'), 
    % ((MelhorX = MelhorY, !; MelhorX = 3, MelhorY = 1, !; MelhorX = 1, MelhorY = 3), contD(J,N3), N33 is N3 + 1, retractall(contD(J,_)), assert(contD(J,N33)), !; true),
    %writeln('4'), 

    % Faz a melhor jogada
    assert(jogada(J,MelhorX,MelhorY))

    %writeln('5')
    .

/*
    % Avaliação dos Pesos Combinados
    (
        % Ataque Duplo
        (contD(O,2), contX(O,2), !;
        contD(O,2), contY(O,2), !;
        contX(O,2), contY(O,2)), PR is 10, !;

        % Ataque Simples
        (contD(O,2), !;
        contX(O,2), !;
        contY(O,2)), PR is 7, !;

        % Movimentação
        
    )
*/

desenhaMapa :-
    forall(
        mapa(X,Y,_),
        (
            write('['),
            (jogada(J,X,Y), (J = 1, write('X'), !; write('O')), !;
            write(' ')),
            (Y = 3, writeln(']'), !; write(']'))
        )
    ).

/*
 * movimento(J)
 * J: Jogador
 *   - 1: Maximizador (X)
 *   - 2: Minimizador (O)
 */
movimento(J) :- sleep(2), tty_clear, desenhaMapa,
    % Verificar se jogo já está ganho
    verificaVitoria(J1), write('O jogador '), write(J1), writeln(' venceu!'), !;

    % Verificar prioridade de jogada
    avaliacaoEstatica(J),

    % Próximo Jogador
    (J = 1, O is 2, !; O is 1), movimento(O)
    
    .
