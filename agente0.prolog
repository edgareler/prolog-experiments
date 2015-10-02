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

dentroX(X) :- X < 1, !, fail.
dentroX(X) :- X > 11, !, fail.
dentroX(X).
dentroY(Y) :- Y < 1, !, fail.
dentroY(Y) :- Y > 8, !, fail.
dentroY(Y).

naoobst(X,Y) :- obst(X,Y), !, fail.
naoobst(X,Y).

insereelem(X,L,[X|L]).

pertence(X,[X|_]).
pertence(X,[_|Y]) :- pertence(X,Y).

naopertence(X,L) :- pertence(X,L), !, fail.
naopertence(X,L).

filtrarpos([],[],H) :- !.
filtrarpos([(X,Y)|R],[(X,Y)|R1],H) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), filtrarpos(R,R1,H).
filtrarpos([(_,_)|R],R1,H) :- filtrarpos(R,R1,H).

bichoburro(X,Y,H) :- writeln(:(X,Y)), alim(X,Y), !.
bichoburro(X,Y,H) :- gerapos(X,Y,R), filtrarpos(R,[(X1,Y1)|R1],[(X,Y)|H]), bichoburro(X1,Y1,[(X,Y)|H]).

encontraalim(X,Y,X1,Y1) :- alim(AX,AY), X < AX, X > X1, !, fail.
encontraalim(X,Y,X1,Y1) :- alim(AX,AY), X > AX, X < X1, !, fail.
encontraalim(X,Y,X1,Y1) :- alim(AX,AY), Y < AY, Y > Y1, !, fail.
encontraalim(X,Y,X1,Y1) :- alim(AX,AY), Y > AY, Y < Y1, !, fail.
encontraalim(X,Y,X1,Y1).

filtrarposesperto([],[],H) :- !.
filtrarposesperto([(X,Y)|R],[(X,Y)|R1],[(X1,Y1)|H]) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), encontraalim(X,Y,X1,Y1), writeln(:(R)), filtrarposesperto(R,R1,[(X1,Y1)|H]).
/*
filtrarposesperto([(X,Y)|R],[(X,Y)|R1],[(X1,Y1)|H]) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), alim(AX,AY), X > AX, X < X1, filtrarposesperto(R,R1,[(X1,Y1)|H]).
filtrarposesperto([(X,Y)|R],[(X,Y)|R1],[(X1,Y1)|H]) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), alim(AX,AY), Y < AY, Y > Y1, filtrarposesperto(R,R1,[(X1,Y1)|H]).
filtrarposesperto([(X,Y)|R],[(X,Y)|R1],[(X1,Y1)|H]) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), alim(AX,AY), Y > AY, Y < Y1, filtrarposesperto(R,R1,[(X1,Y1)|H]).
filtrarposesperto([(X,Y)|R],[(X,Y)|R1],[(X1,Y1)|H]) :- dentroX(X), dentroY(Y), naoobst(X,Y), naopertence((X,Y),H), filtrarposesperto(R,R1,H).
*/
filtrarposesperto([(_,_)|R],R1,H) :- filtrarposesperto(R,R1,H).

bichoesperto(X,Y,H) :- alim(X,Y), !.
bichoesperto(X,Y,H) :- gerapos(X,Y,R), filtrarposesperto(R,[(X1,Y1)|R1],[(X,Y)|H]), bichoesperto(X1,Y1,[(X,Y)|H]).

