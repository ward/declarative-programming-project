:- consult('containers.pro').
:- consult('matrix.pro').
:- consult('containermanipulation.pro').
:- consult('print.pro').
:- consult('list_operations.pro').


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


% List is output, contains all objects
allObjects(List) :- findall(object(ID, Size), object(ID, Size), List).
% List is output, contains all containers
allContainers(List) :- findall(container(ID, Size, Content), container(ID, Size, Content), List).

% The cuts are to stop it trying to place objects in the air or something.
% This way the object always gets placed as low and as left as possible.
% (in that order).
% All the possibilities will be found by feeding objects into it in a different
% order.
fillContainer(
	container(CID, size(CH, CW, CD), Content),
	[]
) :-
	write('Empty object list'), nl,
	printContainer(container(CID, size(CH, CW, CD), Content)), !.
fillContainer(
	container(CID, size(CH, CW, CD), Content),
	[Object|Objects]
) :-
	checkFree(
		container(CID, size(CH, CW, CD), Content),
		Object,
		H,
		W
	),
	!,
	placeObjectAt(
		container(CID, size(CH, CW, CD), Content),
		Object,
		H,
		W,
		NC
	),
	%printContainer(NC),
	fillContainer(NC, Objects).

% This one gets reached if all previous fail.
fillContainer(
	container(CID, size(CH, CW, CD), Content),
	[Object|Objects]
) :-
	true, !.
	%write('Non empty object list'), nl,
	%printContainer(container(CID, size(CH, CW, CD), Content)).
	%write([Object|Objects]).

% This is shit, trying all permutations is SLOW
findBest(
	container(CID, size(CH, CW, CD), Content),
	ObjectList,
	ObjectSolution,
	AmountOfFreeSpots
) :-
	findall(
		[FS, Objects],
		(
			permutation(ObjectList, ObjectSolution),
			fillContainer(
				container(CID, size(CH, CW, CD), Content),
				ObjectSolution
			)
		),
		Solutions
	).

% In a sequence [1,2,3,4,5,6,7,8], if it fails (in that order) on 4, then there
% is no point in also trying out all the other permutations that start with
% [1,2,3,4,STUFF] since they will all fail on 4 anyway.

tryNext(
	container(CID, size(CH, CW, CD), Content),
	[],
	container(CID, size(CH, CW, CD), Content)
).

% nth0 takes one out, hold the rest. Each will be taken out in turn.
tryNext(
	container(CID, size(CH, CW, CD), Content),
	Objects,
	ResultContainer
) :-
	nth0(N, Objects, Object, OtherObjects),
	%write(Object), nl, write(OtherObjects), nl,
	firstFree(
		container(CID, size(CH, CW, CD), Content),
		Object,
		H,
		W
	),
	placeObjectAt(
		container(CID, size(CH, CW, CD), Content),
		Object,
		H,
		W,
		NC
	),
	tryNext(NC, OtherObjects, ResultContainer).



%%%
% Given an object list.
% Get all the possible splits into two lists
% Noting that a split X = [1], Y = [2,3]
%   is different from X = [2,3], Y = [1]
%  It's a pity cause it doubles checks for nothing. --> so mysubsets
% Order however is not important: X = [1, 2] = [2, 1]
mysubset([], [], []).
mysubset([X|Xs], Y, [X|Zs]) :- mysubset(Xs, Y, Zs).
mysubset(X, [Y|Ys], [Y|Zs]) :- mysubset(X, Ys, Zs).

% sort/2 sorts and removes duplicates
% sort/2 in findall is to make sure things are considered equal in the second
% sort/2.
mysubsets(ListIn, ListOfSplits) :-
	findall(Ls, (mysubset(L1, L2, ListIn), sort([L1, L2], Ls)), L),
	sort(L, ListOfSplits).

all :-
		allObjects(Objects),
		allContainers(Containers),
		nth0(0, Containers, C1),
		nth0(1, Containers, C2),
		mysubsets(Objects, ObjectSplits),
		!, % Cut because the permuting only needs to happen beyond here
		nth0(N, ObjectSplits, [ObjectsContainer1, ObjectsContainer2]),
		tryNext(C1, ObjectsContainer1, C1b),
		tryNext(C2, ObjectsContainer2, C2b),
		printContainer(C1b), printContainer(C2b).




/*mostobjects :-
	allObjects(O),
	allContainers(Containers),
	nth0(0, Containers, C1),
	nth0(1, Containers, C2),
	permutation(O, Objects),
	fillInOrder(C1, Objects, C1b, RestOfObjects),
	fillInOrder(C2, RestOfObjects, C2b, Leftovers),
	length(Leftovers, N), write(N), nl.*/



%% Requirement 4: No bigger on top of a smaller one.
% Heuristic: sort by size, alternatively place in container 1 and container 2.

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
	

smallontop :-
	allObjects(O),
	container(1, C1),
	container(2, C2),
	sort_by_volume(O, O2),
	reverse(O2, Objects),
	fill_balanced(C1, C2, Objects).

fill_balanced(C1, C2, []) :- printContainer(C1), printContainer(C2).
fill_balanced(C1, C2, [O|Os]) :- 
	container_weight(C1, N1),
	container_weight(C2, N2),
	N1 =< N2,
	firstFree(C1, O, H, W),
	placeObjectAt(C1, O, H, W, NewC1),
	fill_balanced(NewC1, C2, Os).
% C2 is the heavier one or no spot for object
fill_balanced(C1, C2, Os) :- fill_balanced(C2, C1, Os).
% No free spot there either, skip this one.
fill_balanced(C1, C2, [O|Os]) :- fill_balanced(C1, C2, Os).
