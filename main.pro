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
	Width is W.


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
	write('Empty object list'),
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
	write('Non empty object list'),
	printContainer(container(CID, size(CH, CW, CD), Content)).
	%write([Object|Objects]).
