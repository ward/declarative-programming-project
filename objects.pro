object_volume(object(_, size(H, W, D)), N) :-
	N is H * W * D.

% using an insertion sort
sort_by_volume(Objects, Sorted) :- sort_by_volume(Objects, [], Sorted).

sort_by_volume([], Acc, Acc).
sort_by_volume([H|T], Acc, Sorted) :-
	insert_object(H, Acc, NewAcc),
	sort_by_volume(T, NewAcc, Sorted).
% Insert object in a sorted spot
insert_object(X, [Y|T], [Y|NT]) :-
	object_volume(X, Nx),
	object_volume(Y, Ny),
	Nx > Ny,
	insert_object(X,T,NT).
insert_object(X, [Y|T], [X,Y|T]) :-
	object_volume(X, Nx),
	object_volume(Y, Ny),
	Nx =< Ny.
% Reached the end
insert_object(X, [], [X]).


% List is output, contains all objects
allObjects(List) :- findall(object(ID, Size), object(ID, Size), List).
