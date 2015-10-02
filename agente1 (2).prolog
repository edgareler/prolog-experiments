dim(11,8).

obst(4,4).
obst(4,5).
obst(4,6).
obst(7,5).
obst(7,6).
obst(7,7).
obst(8,2).
obst(8,3).
obst(8,4).
alim(11,3).

gerapos(X,Y,[(Z1,Y),(Z2,Y),(X,W1),(X,W2)]) :- Z1 is X - 1, Z2 is X + 1, W1 is Y - 1, W2 is Y + 1.

insereelem(X,L,[X|L]).

numpar(X) :- X mod 2 =:= 0.
numimpar(X) :- X mod 2 =\= 0.

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(X,L).

diferentes(X,X) :- !, fail.
diferentes(X,Y).

naoobst(X,Y) :- obst(X,Y), !, fail.
naoobst(X,Y).

/* naoalim(X,Y) :- alim(X,Y), !, fail.
naoalim(X,Y). */

dentroX(X) :- X < 1, !, fail.
dentroX(X) :- X > 11, !, fail.
dentroX(X).
dentroY(Y) :- Y < 1, !, fail.
dentroY(Y) :- Y > 8, !, fail.
dentroY(Y).

foraX(X) :- dentroX(X), !, fail.
foraX(X).
foraY(Y) :- dentroY(Y), !, fail.
foraY(Y).

filtrarpos([],[]) :- !.
filtrarpos([(X,Y)|R],[(X,Y)|R1]) :- X > 0, dim(D1,D2), X <= D1, Y > 0, Y <= D2, filtrarpos(R,R1)

/*
achoualim(X,Y,L) :- write(:(X,Y)), alim(X,Y), !.
achoualim(X,Y,L) :- dentroX(X), !, X1 is X - 1, achoualim(X1,Y,L).
achoualim(X,Y,L) :- dentroY(Y), !, Y1 is Y - 1, achoualim(X,Y1,L).
*/

/*
achoualim(X,Y,L) :- dentroY(Y), !, Y1 is Y - 1, achoualim(X,Y1,L).
*/

/*achoualim(X,Y,L) :- X1 is X + 1, Y1 is Y + 1, naoobst(X,Y), dentroX(X), dentroY(Y), achoualim(X1,Y1,L).
*/

/* achoualim(X,Y) :- alim(X1,Y1), writeln(:(X1,Y1)), naoobst(X1,Y1), dentro(X1,Y1), achoualim(X1,Y1), X1 is X + 1, Y1 is Y + 1. */
