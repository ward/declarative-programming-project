:- consult('containers_def.pro').
:- consult('matrix.pro').
:- consult('containers.pro').
:- consult('objects.pro').
:- consult('print.pro').


% Checks if object can be placed at position (W, H) in matrix of container.
checkFree(
	container(ID, size(CH, CW, CD), Content),
	object(_, size(OH, OW, _)),
	H,
	W
) :-
	matrix_nth0_block(W, H, W2, H2, Content, 0),
	H2 is H + OH,
	W2 is W + OW.

% Give the first free result and don't look further.
firstFree(
	container(ID, size(CH, CW, CD), Content),
	object(_, size(OH, OW, _)),
	H,
	W
) :-
	checkFree(
		container(ID, size(CH, CW, CD), Content),
		object(_, size(OH, OW, _)),
		H,
		W
	), !.


%% Requirement: Best balance and minimal space usage
% Heuristic: sort by size (big to small), place in most empty container

balanced :-
	allObjects(O),
	container(1, C1),
	container(2, C2),
	sort_by_volume(O, O2),
	reverse(O2, Objects),
	fill_balanced(C1, C2, Objects, []).

fill_balanced(C1, C2, [], Skipped) :-
	printContainer(C1),
	printContainer(C2),
	write('Skipped: '), write(Skipped), nl,
	!. % We're happy with just one solution.
fill_balanced(C1, C2, [O|Os], Skipped) :- 
	container_weight(C1, N1),
	container_weight(C2, N2),
	N1 =< N2,
	firstFree(C1, O, H, W),
	placeObjectAt(C1, O, H, W, NewC1),
	fill_balanced(NewC1, C2, Os, Skipped).
% C2 is the heavier one or no spot for object
fill_balanced(C1, C2, [O|Os], Skipped) :-
	firstFree(C2, O, H, W),
	placeObjectAt(C2, O, H, W, NewC2),
	fill_balanced(C1, NewC2, Os, Skipped).
% No free spot there either, skip this one.
fill_balanced(C1, C2, [O|Os], Skipped) :- fill_balanced(C1, C2, Os, [O|Skipped]).
