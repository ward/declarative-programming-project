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


% fill_balanced takes a list of objects and places them one at a time in the
% emptiest container at that point. Objects that don't fit get added to Skipped.
% In the end the objects to place is empty and the containers are printed out
% as well as which objects were skipped.

% End of the line
fill_balanced(C1, C2, [], Skipped) :-
	printContainer(C1),
	printContainer(C2),
	write('Skipped: '), write(Skipped), nl.
% See if C1 is emptier and try placing object
fill_balanced(C1, C2, [O|Os], Skipped) :- 
	container_empty_spots(C1, N1),
	container_empty_spots(C2, N2),
	N1 =< N2,
	firstFree(C1, O, H, W),
	placeObjectAt(C1, O, H, W, NewC1),
	!, % We're happy with one solution.
	fill_balanced(NewC1, C2, Os, Skipped).
% C2 is the emptier one or no spot for object in C1
fill_balanced(C1, C2, [O|Os], Skipped) :-
	firstFree(C2, O, H, W),
	placeObjectAt(C2, O, H, W, NewC2),
	!, % We're happy with one solution.
	fill_balanced(C1, NewC2, Os, Skipped).
% No free spot in C2 either, skip this object.
fill_balanced(C1, C2, [O|Os], Skipped) :- fill_balanced(C1, C2, Os, [O|Skipped]).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MAIN FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Place all objects in the program into the containers, if possible.
place_objects :-
	allObjects(O),
	container(1, C1),
	container(2, C2),
	sort_by_volume(O, O2),
	reverse(O2, Objects),
	fill_balanced(C1, C2, Objects, []).
