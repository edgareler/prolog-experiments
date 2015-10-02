predecessor(joao, jose).
predecessor(joao, lia).
predecessor(maria,jose).
predecessor(jose,ana).
predecessor(jose,patricia).
predecessor(patricia, felipe).
filho(Y,X):- predecessor(X,Y).
femea(lia).
femea(maria).
femea(ana).
femea(patricia).
macho(joao).
macho(jose).
macho(felipe).
mae(X,Y) :- predecessor(X,Y), femea(X).
pai(X,Y) :- predecessor(X,Y), macho(X).
ancestral(X,Y) :- predecessor(X,Y),!.
ancestral(X,Y) :- predecessor(X,Z), writeln(:(X,Z)), ancestral(Z,Y).