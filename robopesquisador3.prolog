/* Programa: Robô Pesquisador.
 * Versão: 3.0
 * Descrição: Programa que controla um robô e seus robôs pesquisadores filhos que entram em uma construção térrea e
 *			  e faz um levantamentamento de todos os objetos existentes nas salas.
 * Autores: Edgar Eler / Thiago de Oliveira Tuler.
 * Data: 26/05/2014.
 */

/*
 * robo(R,T,P,S)
 * R: Identificação do Robô
 * T: Tipo do Robô (1: Coordenador, 2: Pesquisador)
 * P: Parent (Antecessor)
 * S: Sala de Localização do Robô
 */
:- dynamic robo/4.
robo(1,1,-1,0).

% Predicado básico de verificação de item na lista
pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

cabeca(X,[X|_]).

adiciona(X,L,[X|L]).

/* base(B,T,I,P)
 * B: Base (0: Natureza, 1: Robô)
 * T: Tipo (0: Sala, 1: Objeto)
 * I: Identificador:
 *      - Sala: Número (0,1,2,3,...)
 *      - Porta: Status (1: Aberta, -1: Fechada)
 *      - Objeto: Nome
 * P: Parent (Antecessor)
 */
:- dynamic base/4.

% Sala 0 - Edifício
base(0,0,0,(-1)).
% Sala 1
base(0,0,1,0).
% Sala 2
base(0,0,2,0).
% Sala 3
base(0,0,3,0).
% Sala 31
base(0,0,31,3).
% Sala 32
base(0,0,32,3).
% Sala 31
base(0,0,33,3).
% Sala 4
base(0,0,4,0).
% Sala 5
base(0,0,5,0).
% Sala 51
base(0,0,51,5).
% Sala 511
base(0,0,511,51).
% Objetos da Sala 1
base(0,1,granada,1).
base(0,1,explosivo,1).
% Objetos da Sala 2
% Vazia
% Objetos da Sala 3
base(0,1,faca,3).
% Objetos da Sala 31
base(0,1,mapa,31).
base(0,1,bussola,31).
base(0,1,gps,31).
% Objetos da Sala 4
base(0,1,polvora,4).
% Objetos da Sala 5
base(0,1,fuzil,5).
base(0,1,pistola,5).
% Objetos da Sala 51
base(0,1,ied,51).
base(0,1,rpg,51).
base(0,1,ak47,51).
% Objetos da Sala 511
base(0,1,tridentII,511).
base(0,1,agm129,511).
base(0,1,bulava,511).

/*
 * Pesquisa as salas e objetos em determinada sala
 */
pesquisar(R,S) :- forall(base(0,T,I,S), assert(base(R,T,I,S))).

/*
 * Extrai as salas e objetos armazenados no robô pesquisador e salva em seu robô coordenador
 */
armazenar(R,S) :- robo(R1,2,R,_), writeln('Armazenados:'), forall(base(R1,T,I,S), ((T = 0, write('- Sala '); write('- Objeto ')), writeln(I), assert(base(R,T,I,S)))).

/*
 * Envia as salas e objetos armazenados no robô coordenador filho para seu robô coordenador pai
 */
enviar(R) :- robo(R,_,RC,_), forall(base(R,T,I,S), assert(base(RC,T,I,S))), write('Informacoes enviadas do robo com ID '), write(R), write(' para o robo com ID '), writeln(RC).

relatorio(R) :- writeln(''), write('Relatorio do robo '), writeln(R), forall( base(R,T,I,P), ( (T = 0, write('- Sala '); write('- Objeto ')), write(I), write(', filho da sala '), writeln(P)) ).

/*
 * caminhar(S,R,P)
 * S: Sala
 * R: Robô
 * P: Sala Pesquisada (0: False, 1: True)
 */
caminhar(S,R,P) :- 
            % Robô Coordenador recebe Lista de Salas e Objetos
            robo(R,T,RC,_), T = 1, P = 1, write('Armazenando no robo coordenador... '), armazenar(R,S),
                % Robô Pesquisador é destruído
                robo(RP,2,R,_), retractall(base(RP,_,_,_)), retractall(robo(RP,_,_,_)), write('* Robo pesquisador com ID '), write(RP), writeln(' destruido.'),
                % Novos Robôs Coordenadores são criados com base nas salas coletadas, e o processo é reiniciado para cada sala
                ( base(R,0,S1,S), forall( base(R,0,S1,S), (random_between(100000,999999,RC1), assert(robo(RC1,1,R,S1)), write('Enviando robo coordenador com ID '), writeln(RC1), caminhar(S1,RC1,0)) ) ; true ),
                % Caso o Robô Coordenador possua um antecessor, ele envia as informações para o robô coordenador pai e em seguida ele é destruído
                (RC > 0, enviar(R), retractall(base(R,_,_,_)), retractall(robo(R,_,_,_)), write('* Robo coordenador com ID '), write(R), writeln(' destruido.'); true),
                % Caso o Robô Coordenador não possua um antecessor, a recursão é encerrada
                RC = -1, relatorio(R), !;

            % Robô Coordenador envia Pesquisador
            robo(R,T,_,_), T = 1, P = 0, random_between(100000,999999,RP), assert(robo(RP,2,R,S)), write('Enviando robo pesquisador com ID '), writeln(RP), caminhar(S,RP,1);

            % Robô Pesquisador
            robo(R,T,RC,_), T = 2, write('Pesquisando... '), pesquisar(R,S), write('Pesquisa concluida. Voltando para o robo coordenador com ID '), writeln(RC), caminhar(S,RC,1).



