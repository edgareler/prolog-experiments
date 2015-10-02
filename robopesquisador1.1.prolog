/* Primeira Versão do Robô Pesquisador */

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

geraRelatorio :-
	base(1,S,_,L),   %Consulta base do robô
	S>=1,            %A partir da sala 1
	write('Sala: '), %Gera relatório
	write(S),
	write(', Objetos: '),
	writeln(L),
	false.		 %Até não haver mais nada a ser consultado

caminhar(S) :-
	S = 0, base(1,S,1,_), retract(base(0,S,1,[])), assert(base(0,0,-1,[])), !;
	S = 0, retract(base(0,S,-1,[])), assert(base(0,S,1,[])), assert(base(1,S,1,_)), S1 is S + 1, caminhar(S1), !, geraRelatorio;
	S > 0, (
                base(0,S,P,L), P = -1, assert(base(1,S,P,_)), P1 is P * -1, retract(base(0,S,P,L)), assert(base(0,S,P1,L)), caminhar(S);
                base(0,S,P,L), P = 1, retractall(robo(_)), assert(robo(S)), (base(1,S,PX,_); PX is P), retractall(base(1,S,_,_)), assert(base(1,S,PX,L)), retract(base(0,S,P,L)), assert(base(0,S,PX,L)), S1 is S + 1, caminhar(S1)
                ),!;
        caminhar(0).


