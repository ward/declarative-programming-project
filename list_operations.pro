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
listInList([], []).
listInList(_, []) :- fail.
listInList(List1, [X|Xs]) :- prefix(List1, [X|Xs]).
listInList(List1, [_|Xs]) :- listInList(List1, Xs).

% If it returns false, that means you're dropping more elements
% than there are in the List.
% Cut so we don't get empty list as result on every call
dropN(List, N, Output) :- length(X, N), append(X, Output, List), !.
dropN(_, _, []).

listInListAt(ListNeedle, ListHay, N) :- dropN(ListHay, N, NewList), prefix(ListNeedle, NewList).

% Creates a list of N elements initialized with Value
% Cut to not keep looking endlessly after creating one.
createList(0, _, []) :- true, !.
createList(N, Value, [Value|List]) :- N0 is N - 1, createList(N0, Value, List).

% See if block of Value is at position X, Y in matrix
% Y is index for outer array, X for inner
blockInMatrix(_, _, _, _, _, 0).
blockInMatrix([M|Ms], X, 0, Value, Width, Height) :-
	createList(Width, Value, L),
	listInListAt(L, M, X),
	H is Height - 1,
	blockInMatrix(Ms, X, 0, Value, Width, H).
blockInMatrix(Matrix, X, Y, Value, Width, Height) :-
	Y \= 0,
	dropN(Matrix, Y, NewMatrix),
	blockInMatrix(NewMatrix, X, 0, Value, Width, Height).


%
listCombinations_membersOfLists(E1, L1, E2, L2) :- member(E1, L1), member(E2, L2).
listCombinations(L1, L2, ListOut) :- findall([X, Y], listCombinations_membersOfLists(X, L1, Y, L2), ListOut).
