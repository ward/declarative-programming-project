:- consult('containers.pro').
:- consult('containermanipulation.pro').
:- consult('print.pro').
:- consult('list_operations.pro').




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% By definition a coordinate in a container is free if it equals 0.
findFreeSpot(
	container(_, _, [Row|_]),
	FreeHeight,
	FreeWidth
) :-
	nth0(FreeWidth, Row, 0),
	FreeHeight is 0.
% Now if there wasn't one free in the previous, we try on the next
findFreeSpot(
	container(ID, size(CH, CW, CD), [_|Rows]),
	FreeHeight,
	FreeWidth
) :-
	CH2 is CH - 1,
	findFreeSpot(
		container(ID, size(CH2, CW, CD), Rows),
		FH,
		FreeWidth
	),
	FreeHeight is FH + 1.

% Now use findFreeSpot to get all the free spots in container
allFreeSpots(
	container(ID, size(CH, CW, CD), Content),
	Freespots
) :-
	findall(
		[H, W],
		findFreeSpot(
			container(ID, size(CH, CW, CD), Content),
			H,
			W
		),
		Freespots
	).

% Checks for Height and Width position if object can be placed there
% (matching the lower left corner of the object to the position)
checkFree(
	container(ID, size(CH, CW, CD), [Row|Rows]),
	object(_, size(OH, OW, _)),
	Height,
	Width
) :-
	allFreeSpots(container(ID, size(CH, CW, CD), [Row|Rows]), Freespots),
	member([H, W], Freespots),
	WidthEnd is W + OW - 1,
	HeightEnd is H + OH - 1,
	numlist(W, WidthEnd, Xs),
	numlist(H, HeightEnd, Ys),
	listCombinations(Ys, Xs, Combined),
	subset(Combined, Freespots),
	Height is H,
	Width is W,
	!.


% List is output, contains all objects
allObjects(List) :- findall(object(ID, Size), object(ID, Size), List).

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
	[]
) :- true.

% nth0 takes one out, hold the rest. Each will be taken out in turn.
tryNext(
	container(CID, size(CH, CW, CD), Content),
	Objects
) :-
	nth0(N, Objects, Object, OtherObjects),
	%write(Object), nl, write(OtherObjects), nl,
	checkFree(
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
	tryNext(NC, OtherObjects).



%%%
% Given an object list.
% Get all the possible splits into two lists
% Noting that a split X = [1], Y = [2,3]
%   is different from X = [2,3]. Y = [1]
% Order however is not important: X = [1, 2] = [2, 1]
mysubset([], [], []).
mysubset([X|Xs], Y, [X|Zs]) :- mysubset(Xs, Y, Zs).
mysubset(X, [Y|Ys], [Y|Zs]) :- mysubset(X, Ys, Zs).
