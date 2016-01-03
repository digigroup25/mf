% Prolog explorer robot

% 15 may 2002 - J. Vaucher


go :- receive(_,Msg), handle( Msg ), state(D,X,Y), println(state(D,X,Y)).

handle(init(X,Y)) :- rnd_choice([e,w,n,s],Dir),
                     assert( state(Dir,X,Y) ),
                     suc(Dir,X,Y,X1,Y1),
                     visit(X,Y), visit( X1,Y1),
                     assert( try(go(X1,Y1)) ),
                     send( 0, go(Dir) ).


handle(ok) :- retract( try( go(X,Y)) ), 
              retract(state(Dir,_,_)) ,
              assert( state(Dir,X,Y)),
              
              suc(Dir,X,Y, X1,Y1),
              
	          visit(X1,Y1) ,
              assert( try(go(X1,Y1)) ),
              send( 0, go(Dir) ).

handle( Obstacle ) :-  
      retract(state(Dir,X,Y)) ,
      retract( try( go(X2,Y2)) ), 
      add( contains(X2,Y2, Obstacle)),
      find_move(X,Y).
      
      
find_move(X,Y) :-
	suc(D,X,Y, X1,Y1), 
	not( visited(X1,Y1) ),!,   % try unvisited neighbour
	assert( state(D,X,Y) ),
	do_move( D, X1,Y1), !.
  
find_move(X,Y) :-
    repeat, 
    	rnd_choice([e,w,n,s],D),   % try random unobstructed direction
		suc(D,X,Y, X1,Y1), 
	not( contains(_, X1,Y1) ),
	assert( state(D,X,Y) ),
	do_move( D, X1,Y1), !.
    
do_move( D, X,Y ) :- visit(X,Y),
	assert( try( go(X,Y) )),
    send(0,go(D)).

add(X) :- call(X),!.
add(X) :- assert(X).

visit(X,Y) :- visited(X,Y), !.
visit(X,Y) :- assert(visited(X,Y)).

suc(e,X,Y, X2,Y)  :- X2 is X+1.
suc(s,X,Y, X,Y2)  :- Y2 is Y-1.
suc(w,X,Y, X2,Y)  :- X2 is X-1.
suc(n,X,Y, X,Y2)  :- Y2 is Y+1.


% -------------- Utilities --------------------------------

rnd_choice(L,Res) :- length(L,N), P is rnd(N),nth(P,L,Res).

length([],0):- !.
length([_|Rest],L2):- length(Rest,L), L2 is L+1.

nth(0,[A|_],A).
nth(N,[_|Tail],X):- N>0, N2 is N-1, nth(N2,Tail,X).


set_minus(S1,[],S1).
set_minus(S1,[E1|Tail],Sn):-
   remove(E1,S1,S2), set_minus(S2,Tail,Sn).

remove(X,[],[]).
remove(X,[X|Tail],L2):- !, remove(X,Tail,L2).
remove(X,[E|Tail],[E|L2]):- !, remove(X,Tail,L2).

member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

message(X) :- print('Robot sends: '), println(X).

repeat.
repeat :- repeat.
