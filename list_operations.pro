% Some list stuff

% true if Value occurs Amount times in the list
occursInList([], _, 0).
occursInList([Value|Xs], Value, Amount) :-
	occursInList(Xs, Value, A),
	Amount is A + 1.
occursInList([X|Xs], Value, Amount) :-
	X \= Value,
	occursInList(Xs, Value, Amount).

% True if first list is in second one
listInList(List1, []) :- fail.
listInList(List1, [X|Xs]) :- prefix(List1, [X|Xs]).
listInList(List1, [X|Xs]) :- listInList(List1, Xs).
