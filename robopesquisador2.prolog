/* Programa: Robô Pesquisador.
 * Versão: 2.0
 * Descrição: Programa que controla um robô que entra em uma construção térrea e
 *			  e faz um levantamentamento de todos os objetos existentes nas salas.
 * Autores: Edgar Eler / Thiago de Oliveira Tuler.
 * Data: 26/05/2014.
 */

:- dynamic base/8.
:- dynamic robo/2.
robo(0,0).

% Predicado básico de verificação de item na lista
pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

cabeca(X,[X|_]).

/* base(B,T,I,X,Y,W,H,P)
 * B: Base (0: Natureza, 1: Robô)
 * T: Tipo (0: Sala, 1: Porta, 2: Objeto)
 * I: Identificador:
 *      - Sala: Número (0,1,2,3,...)
 *      - Porta: Status (1: Aberta, -1: Fechada)
 *      - Objeto: Nome
 * X: Posição no Eixo X
 * Y: Posição no Eixo Y
 * W: Largura
 * H: Altura
 * P: Parent (Antecessor)
 */
% Sala 0 - Edifício
base(0,0,0,0,0,240,300,(-1)).
% Sala 1
base(0,0,1,140,0,100,100,0).
% Sala 2
base(0,0,2,0,0,100,100,0).
% Sala 3
base(0,0,3,140,100,100,100,0).
% Sala 4
base(0,0,4,0,100,100,100,0).
% Sala 5
base(0,0,5,140,200,100,100,0).
% Porta da Sala 0 - Edifício
base(0,1,-1,100,0,40,1,0).
% Porta da Sala 1
base(0,1,-1,140,30,1,40,1).
% Porta da Sala 2
base(0,1,1,100,30,1,40,2).
% Porta da Sala 3
base(0,1,-1,140,130,1,40,3).
% Porta da Sala 4
base(0,1,-1,100,130,1,40,4).
% Porta da Sala 5
base(0,1,1,140,230,1,40,5).
% Objetos da Sala 1
base(0,2,granada,160,20,2,2,1).
base(0,2,explosivo,220,80,4,4,1).
% Objetos da Sala 2
% Vazia
% Objetos da Sala 3
base(0,2,faca,160,120,2,2,3).
% Objetos da Sala 4
base(0,2,polvora,20,120,10,10,4).
% Objetos da Sala 5
base(0,2,fuzil,160,220,8,8,5).
base(0,2,pistola,220,260,4,4,5).

% Será porta se a posição X,Y estiver entre o começo da porta e sua altura/largura
% Falta acertar verificação da porta - Não pode haver comparação entre X instanciado e X1 não instanciado
% porta(X,Y,S) :- base(0,1,_,X1,Y1,W,H,S1), X1 =< X, X =< (X1 + W), Y1 =< Y, Y =< (Y1 + H), S is S1.
porta(X,Y,S) :- base(0,1,_,X,Y,_,_,S1), S is S1;
    X1 is X + 1, base(0,1,_,X1,Y,_,_,S1), S is S1;
    Y1 is Y + 1, base(0,1,_,X,Y1,_,_,S1), S is S1;
    X2 is X - 1, base(0,1,_,X2,Y,_,_,S1), S is S1;
    Y2 is Y - 1, base(0,1,_,X,Y2,_,_,S1), S is S1.

% Será parede se não for porta e se quando X for igual a X1, Y estiver entre a posição e a altura da sala, e vice versa
parede(X,Y) :- not(porta(X,Y,_)), base(0,0,_,X1,Y1,W,H,_), (X1 = X, Y1 =< Y, Y =< (Y1 + H); Y1 = Y, X1 =< X, X =< (X1 + W)).

% Será objeto se a posição X,Y estiver entre o começo do objeto e sua altura/largura
% objeto(X,Y,I,S) :- base(0,2,I1,X1,Y1,W,H,S1), X1 =< X, X =< (X1 + W), Y1 =< Y, Y =< (Y1 + H), S is S1, I is I1.
objeto(X,Y,I,S) :- base(0,2,I1,X,Y,_,_,S1), S is S1, I is I1;
    X1 is X + 1, base(0,2,I1,X1,Y,_,_,S1), S is S1, I is I1;
    Y1 is Y + 1, base(0,2,I1,X,Y1,_,_,S1), S is S1, I is I1;
    X2 is X - 1, base(0,2,I1,X2,Y,_,_,S1), S is S1, I is I1;
    Y2 is Y - 1, base(0,2,I1,X,Y2,_,_,S1), S is S1, I is I1.

% Acessa porta encontrada
acessaPorta(X,Y,W,H,C,X2,Y2) :- 
    % Verifica se a porta é Vertical (Largura = 1). Verifica também se o X anterior era menor ou maior que o atual
    % para traçar a direção para entrar na porta
    (W = 1, cabeca((X1,_),C), (X > X1, X2 is X + 1; X < X1, X2 is X - 1), Y2 is Y;

    % Verifica se a porta é Horizontal (Altura = 1). Verifica também se o Y anterior era menor ou maior que o atual
    % para traçar a direção para entrar na porta
     H = 1, cabeca((_,Y1),C), (Y > Y1, Y2 is Y + 1; Y < Y1, Y2 is Y - 1), X2 is X),

    % Entra na porta
    retractall(robo(_,_)), assert(robo(X2,Y2)), write('movexy '), write(X2), write(' '), writeln(Y2).

/*
 * caminhar(X,Y,S)
 * X: Posição X
 * Y: Posição Y
 * C: Lista do Caminho (X,Y) Percorrido
 * S: Sala atual
 */
caminhar(X,Y,C,S) :- 
    % Base da Recursão: Sala 0 armazenada na Base do Robô = saída do edifício
    base(1,0,0,_,_,_,_,_), writeln('Concluido.'), !;

    % Verifica se é porta, se for, verifica se a porta já foi visitada, se não foi, abre a porta e entra na sala.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % O PROBLEMA ESTÁ AQUI!! O ROBÔ NUNCA ACESSA A PORTA %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    porta(X,Y,S1), not(base(1,1,_,X,Y,_,_,S1)), base(0,1,I,_,_,W1,H1,S1), assert(base(1,1,I,X,Y,W1,H1,S1)),
        (I = -1, retractall(base(0,1,I,XP,YP,W1,H1,S1)), assert(base(0,1,1,XP,YP,W1,H1,S1)); true), write('Porta Aberta. Sala: '), writeln(S1), 

        % Acessa Porta
        acessaPorta(X,Y,W1,H1,C,X2,Y2), caminhar(X2,Y2,[(X2,Y2)|C],S1);

    % Verifica se é objeto
    objeto(X,Y,I,S2), not(base(1,2,I,X,Y,_,_,S1)), base(0,2,I,_,_,W2,H2,S2), assert(base(1,2,I,X,Y,W2,H2,S1)), write('Objeto: '), writeln(I);

    % Verifica se não é parede e se já não foi percorrido, caso não tenha sido, caminha
    (X3 is X + 1, not(porta(X3,Y,_)), not(pertence((X3,Y),C)), not(parede(X3,Y)), retractall(robo(_,_)), assert(robo(X3,Y)), write('movexy '), write(X3), write(' '), writeln(Y), caminhar(X3,Y,[(X3,Y)|C],S);
     Y3 is Y + 1, not(porta(X,Y3,_)), not(pertence((X,Y3),C)), not(parede(X,Y3)), retractall(robo(_,_)), assert(robo(X,Y3)), write('movexy '), write(X), write(' '), writeln(Y3), caminhar(X,Y3,[(X,Y3)|C],S);
     X4 is X - 1, not(porta(X4,Y,_)), not(pertence((X4,Y),C)), not(parede(X4,Y)), retractall(robo(_,_)), assert(robo(X4,Y)), write('movexy '), write(X4), write(' '), writeln(Y), caminhar(X4,Y,[(X4,Y)|C],S);
     Y4 is Y - 1, not(porta(X,Y4,_)), not(pertence((X,Y4),C)), not(parede(X,Y4)), retractall(robo(_,_)), assert(robo(X,Y4)), write('movexy '), write(X), write(' '), writeln(Y4), caminhar(X,Y4,[(X,Y4)|C],S));

    % Quando completar os movimentos, sai da sala. Busca a porta da sala na Base do Robô e caminha até ela.
    base(1,1,I5,X5,Y5,W5,H5,S), retractall(robo(_,_)), assert(robo(X5,Y5)), write('movexy '), write(X5), write(' '), writeln(Y5),

        % Acessa Porta
        acessaPorta(X5,Y5,W5,H5,C,X6,Y6),

        % Armazena Sala na Base do Robô
        base(0,0,S,_,_,_,_,S6), assert(base(1,0,S,_,_,_,_,S6)),

        % Altera a Porta para o Estado Anterior na Base da Natureza
        retractall(base(0,1,_,_,_,_,_,S)), assert(base(0,1,I5,X5,Y5,W5,H5,S)),

        % Caminha para fora da Porta
        write('Saiu da Porta - Sala: '), writeln(S), caminhar(X6,Y6,[(X6,Y6)|C],S6).

