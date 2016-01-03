quicksort( [], []).

quicksort( [X|Tail], Sorted)  :-
   split( X, Tail, Small, Big),
   quicksort( Small, SortedSmall),
   quicksort( Big, SortedBig),
   conc( SortedSmall, [X|SortedBig], Sorted).

split( X, [], [], []).

split( X, [Y|Tail], [Y|Small], Big)  :-
   X > Y, !,
   split( X, Tail, Small, Big).

split( X, [Y|Tail], Small, [Y|Big])  :-
   split( X, Tail, Small, Big).
