/* Programa: Robô Pesquisador.
 * Versão: 1.1
 * Descrição: Programa que controla um robô que entra em uma construção térrea e
 *			  e faz um levantamentamento de todos os objetos existentes nas salas.
 * Autores: Edgar Eler / Thiago de Oliveira Tuler.
 * Data: 19/05/2014.
 */

:- dynamic base/4.
:- dynamic robo/1.
robo(0).

/* base(B,S,P,L)
 * B: Base (0: Natureza, 1: Robô)
 * S: Sala
 * P: Porta Aberta (-1: Fechada, 1: Aberta)
 * L: Lista de Objetos
 */

base(0,0,-1,[]).
base(0,1,-1,[circulo]).
base(0,2,1,[]).
base(0,3,-1,[quadrado,triangulo]).
base(0,4,-1,[losangulo]).
base(0,5,1,[]).
/* base(1,0,0,[]). */

%Escaneia objetos da sala e retorna uma lista de objetos
lerObjetos([],[]) :-
	!.
lerObjetos([C|R1],[C|R3]) :-
	lerObjetos(R1,R3).
%Apaga informações da sala caso esta já esteja na base do robo
apagarSituacao(S) :- 
	base(1,S,_,_),
	retractall(base(1,S,_,_)),!;
	true.
%Grava situação da sala
gravarSituacao(S) :- 
	base(0,S,P,_), P = -1, (base(1,S,PX,_); PX is P), apagarSituacao(S), assert(base(1,S,PX,_)), !;
	base(0,S,P,L), P = 1, (base(1,S,PX,_); PX is P), lerObjetos(L,LX), apagarSituacao(S), assert(base(1,S,PX,LX)).
%Altera estado da porta (-1: Fechada, 1: Aberta)
alterarPorta(S) :- 
	base(0,S,P,L), P = -1,	PX is P * -1, retract(base(0,S,P,L)), assert(base(0,S,PX,L)),!;
	base(0,S,P,L), P = 1, (base(1,S,PX,_); PX is P), retract(base(0,S,P,L)), assert(base(0,S,PX,L)).
%Altera posição do robo
moverRobo(S) :- 
	retractall(robo(_)),
	assert(robo(S)).
%Gera relatório da visitação
gerarRelatorio :- 
	base(1,S,_,L),   %Consulta base do robô
	S>=1,            %A partir da sala 1
	write('Sala: '), %Gera relatório
	write(S),
	write(', Objetos: '),
	writeln(L),
	false.		     %Até não haver mais nada a ser consultado
%Coordena o caminhamento do robô
caminhar(S) :- 
	S = 0, base(0,S,1,_), moverRobo(S), gravarSituacao(S), alterarPorta(S), not(gerarRelatorio), !;
	S = 0, gravarSituacao(S), alterarPorta(S), S1 is S + 1, caminhar(S1), !;
	S > 0, (
	        base(0,S,P,L), P = -1, gravarSituacao(S), alterarPorta(S), caminhar(S);
	        base(0,S,P,L), P = 1, moverRobo(S), gravarSituacao(S), alterarPorta(S), S1 is S + 1, caminhar(S1)
	       ),!;
        caminhar(0).


