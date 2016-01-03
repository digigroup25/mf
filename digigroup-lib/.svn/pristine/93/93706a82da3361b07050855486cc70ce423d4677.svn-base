% Robot delivery environment

% Jean Vaucher - 15 May 2002

init :- place(agent(1)), place(agent(2)),
        place( comp(1)), place( comp(2)),
        pos( agent(1),X,Y),
        send(1, init(X,Y)),
        listing(pos/3).

go:- receive(Src, M), handle( M, Src), !, doTurn.
go.

handle(go(Dir), A) :- pos(agent(A),X,Y), 
    arc( Dir,p(X,Y),Pos2),
    moveTo(A, Pos2, Answer),!, send(A, Answer).

handle(go(Dir),A) :- send(A, wall), !.

handle(listing, _ ):- !, listing(pos/3). 
handle( X,_)       :- print('Unkown message received: '), println(X).


moveTo(A,p(X,Y), Thing) :- pos( Thing, X,Y),!.
moveTo(A,p(X,Y), ok) :- retract( pos( agent(A),_,_)),!,
                        assert( pos(agent(A),X,Y)).

place( Thing ) :- repeat, X is rnd(8) + 1, Y is rnd(8)+1, legal(X,Y),!,
        assert( pos( Thing, X,Y)).

legal(X,Y) :- X>0, X<9, Y>0, Y<9, not(pos(_,X,Y)).

arc(e, p(X,Y), p(X1,Y) ) :- suc(X,X1).
arc(w, p(X,Y), p(X1,Y) ) :- suc(X1,X).
arc(n, p(X,Y), p(X,Y1) ) :- suc(Y,Y1).
arc(s, p(X,Y), p(X,Y1) ) :- suc(Y1,Y).

pos(wall,3,2).
pos(wall,3,3).
pos(wall,3,4).
pos(wall,5,3).
    
suc(1,2).
suc(2,3).
suc(3,4).
suc(4,5).
suc(5,6).
suc(6,7).
suc(7,8).
    
repeat.
repeat :- repeat.
