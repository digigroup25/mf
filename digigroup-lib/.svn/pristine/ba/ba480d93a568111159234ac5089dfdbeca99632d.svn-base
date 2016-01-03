append([],L,L).
append([A|B],L,[A|Tail]) :- append(B,L,Tail).

member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

length([],0).
length([_|Rest],L2):- length(Rest,L), L2 is L+1.

add(X) :- X,!.
add(X) :- assert(X).
