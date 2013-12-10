:- consult('containers.pro').
:- consult('print.pro').
:- consult('list_operations.pro').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Set a value at Height/Width%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Height and width start counting in lower left corner which is (0,0)

% This one doesn't work yet in one command
setValue(container(ID, size(CH, CW, CD), Content), Height, Width, Value, container(ID, size(CH, CW, CD), NewContent)) :-
	setValue_height(Content, Height, Width, Value, NewContent).

setValue_width([_|Y], 0, 0, Value, [Value|Y]).
setValue_width([X|Y], 0, Width, Value, [X|NC]) :-
	W is Width - 1,
	setValue_width(Y, 0, W, Value, NC).

setValue_height([Row|Rows], 0, Width, Value, [NC|Rows]) :-
	setValue_width(Row, 0, Width, Value, NC).
setValue_height([Row|Rows], Height, Width, Value, [Row|NC]) :-
	H is Height - 1,
	setValue_height(Rows, H, Width, Value, NC).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Place a line/object at certain position%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

placeHorizontalLineAt(
	container(ContainerID, size(CH, CW, CD), Content),
	Height,
	Width,
	1,
	Value,
	NewContainer
) :-
	setValue(container(ContainerID, size(CH, CW, CD), Content), Height, Width, Value, NewContainer).

placeHorizontalLineAt(
	container(ContainerID, size(CH, CW, CD), Content),
	Height,
	Width,
	LineWidth,
	Value,
	NewContainer
) :-
	setValue(container(ContainerID, size(CH, CW, CD), Content), Height, Width, Value, NC),
	W is Width + 1,
	LW is LineWidth - 1,
	placeHorizontalLineAt(NC, Height, W, LW, Value, NewContainer).

placeObjectAt(
	container(ContainerID, size(CH, CW, CD), Content),
	object(ObjectID, size(1, ObjectWidth, _)),
	Height,
	Width,
	NewContainer
) :-
	placeHorizontalLineAt(
		container(ContainerID, size(CH, CW, CD), Content),
		Height,
		Width,
		ObjectWidth,
		ObjectID,
		NewContainer
	).

placeObjectAt(
	container(ContainerID, size(CH, CW, CD), Content),
	object(ObjectID, size(ObjectHeight, ObjectWidth, ObjectDepth)),
	Height,
	Width,
	NewContainer
) :-
	placeHorizontalLineAt(
		container(ContainerID, size(CH, CW, CD), Content),
		Height,
		Width,
		ObjectWidth,
		ObjectID,
		NC
	),
	OH is ObjectHeight - 1,
	H is Height + 1,
	placeObjectAt(
		NC,
		object(ObjectID, size(OH, ObjectWidth, ObjectDepth)),
		H,
		Width,
		NewContainer
	).


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
%%%%
% TODO: this command fails to find all free spots (using dataset5)
% container(1, CS, CC), object(1, OS), placeObjectAt(container(1, CS, CC), object(1, OS), 0, 0, NC), printContainer(NC), checkFree(NC, object(2, size(6,2,1)), H, W)
checkFree(
	container(ID, size(CH, CW, CD), [Row|Rows]),
	object(_, size(OH, OW, _)),
	Height,
	Width
) :-
	allFreeSpots(container(ID, size(CH, CW, CD), [Row|Rows]), Freespots),
	member([H, W], Freespots),
	WidthEnd is W + OW,
	HeightEnd is H + OH,
	numlist(W, WidthEnd, Xs),
	numlist(H, HeightEnd, Ys),
	listCombinations(Xs, Ys, Combined),
	subset(Combined, Freespots),
	Height is H,
	Width is W.


% List is output, contains all objects
allObjects(List) :- findall(object(ID, Size), object(ID, Size), List).

fillContainer(
	container(CID, size(CH, CW, CD), Content),
	[]
) :- printContainer(container(CID, size(CH, CW, CD), Content)).
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
	placeObjectAt(
		container(CID, size(CH, CW, CD), Content),
		Object,
		H,
		W,
		NC
	),
	printContainer(NC),
	fillContainer(NC, Objects),
	!.

fillContainer(
	container(CID, size(CH, CW, CD), Content),
	[Object|Objects]
) :-
	printContainer(container(CID, size(CH, CW, CD), Content)),
	write([Object|Objects])
