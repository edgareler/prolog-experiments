/* Procura caminho colaborativamente múltiplos robôs - Mapa grande */

% dimensao(50,30).
dimensao(32,19).
% dimensao(100,60).

alimento(30,15).

% alimento(1,18).

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
%obstaculo(17,7).

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

:- dynamic robo/3.
robo(1,4,6).
robo(2,1,19).
robo(3,24,5).
% robo(4,15,13).

% :- dynamic customaximo/1.
% customaximo(50).

/*
 * base(R,X,Y,T)
 *
 * R: Robô
 * X,Y: Posição
 * T: Tipo
 *   - livre
 *   - obstaculo
 *   - lama
 *   - alimento
 */
:- dynamic base/4.
base(1,4,6,livre).
base(2,1,19,livre).
base(3,24,5,livre).
% base(4,15,13,livre).

proximoRobo(R,R1) :- RT is R + 1, (robo(RT,_,_), R1 is RT; R1 is 1).

dentro(X,Y) :- X > 0, dimensao(DX,DY), X =< DX, Y > 0, Y =< DY.

desconhecido(X,Y) :- base(_,X,Y,_), !, fail.
desconhecido(_,_).

naoobstaculo(R,X,Y) :- obstaculo(X,Y), assert(base(R,X,Y,obstaculo)), !, fail.
naoobstaculo(_,_,_).

item(X,Y) :- 
    alimento(X,Y), write('A'), !;
    obstaculo(X,Y), write('#'), !;
    robo(R,X,Y), write(R), !;
    write(' ').

mapa(X,Y) :- 
    write('['), item(X,Y), write(']'), 
    (dimensao(X,Y), !;
    (dimensao(X,_), X1 is 1, Y1 is Y + 1, writeln(''), !; X1 is X + 1, Y1 is Y), mapa(X1,Y1)).

/*
 * custoponto(X,Y,C)
 * X,Y: Posição
 * X: Custo
 */
% :- dynamic custoponto/3.

/* Para rodar no Windows */
/* substituir tty_clear por cls */
cls :- write('\e[2J').

:- dynamic tempo/1.

proximoPasso(R,X,Y,X1,Y1) :- 
    X1 is X + 1, desconhecido(X1,Y), dentro(X1,Y), naoobstaculo(R,X1,Y), Y1 is Y;
    Y1 is Y + 1, desconhecido(X,Y1), dentro(X,Y1), naoobstaculo(R,X,Y1), X1 is X;
    X1 is X - 1, desconhecido(X1,Y), dentro(X1,Y), naoobstaculo(R,X1,Y), Y1 is Y;
    Y1 is Y - 1, desconhecido(X,Y1), dentro(X,Y1), naoobstaculo(R,X,Y1), X1 is X.

novoCaminhar(R,X,Y) :- % sleep(0.1), tty_clear, mapa(1,1),
    % Quem achar primeiro o alimento deve indicar ao outro e o outro traçar o melhor caminho provável
    alimento(X,Y), assert(base(R,X,Y,alimento)), writeln(''), writeln(''), write('Achou alimento: '), write(X), write(','), write(Y), writeln(''), write('Tempo: '), tempo(TINI), get_time(TFIM), T is TFIM - TINI, write(T), writeln(' seg'), !;
    /* (
    X1 is X + 1, desconhecido(X1,Y), dentro(X1,Y), naoobstaculo(R,X1,Y), assert(base(R,X1,Y,livre)), retractall(robo(R,_,_)), assert(robo(R,X1,Y));
    Y1 is Y + 1, desconhecido(X,Y1), dentro(X,Y1), naoobstaculo(R,X,Y1), assert(base(R,X,Y1,livre)), retractall(robo(R,_,_)), assert(robo(R,X,Y1));
    X2 is X - 1, desconhecido(X2,Y), dentro(X2,Y), naoobstaculo(R,X2,Y), assert(base(R,X2,Y,livre)), retractall(robo(R,_,_)), assert(robo(R,X2,Y));
    Y2 is Y - 1, desconhecido(X,Y2), dentro(X,Y2), naoobstaculo(R,X,Y2), assert(base(R,X,Y2,livre)), retractall(robo(R,_,_)), assert(robo(R,X,Y2))
    ), */

    % Se houver um próximo passo, move o robô
    proximoPasso(R,X,Y,X1,Y1), assert(base(R,X1,Y1,livre)), retractall(robo(R,_,_)), assert(robo(R,X1,Y1)),
    % X e Y estão se mantendo inalterados para robôs presos
    proximoRobo(R,R1), robo(R1,XR,YR),
    % writeln(''), writeln(''), write('Próximo robo: '), write(R1), write(' em '), writeln((XR,YR)),
    novoCaminhar(R1,XR,YR).


iniciar :- get_time(T), assert(tempo(T)), robo(2,X,Y), novoCaminhar(2,X,Y).

