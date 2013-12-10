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

% If it returns false, that means you're dropping more elements
% than there are in the List.
% Cut so we don't get empty list as result on every call
dropN(List, N, Output) :- length(X, N), append(X, Output, List), !.
dropN(List, N, []).

listInListAt(ListNeedle, ListHay, N) :- dropN(ListHay, N, NewList), prefix(ListNeedle, NewList).

% Creates a list of N elements initialized with Value
% Cut to not keep looking endlessly after creating one.
createList(0, _, []) :- true, !.
createList(N, Value, [Value|List]) :- N0 is N - 1, createList(N0, Value, List).
