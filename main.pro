
% Idea based on mail between prof and C. De Troyer:
% Represent a container as a matrix of all 0
% Set things to something else as its place gets taken

% container(id, content)
% Every item in the list of lists is a spot of 1x1x1
container(1, [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]
]).

container(2, [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Printing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prints container (header + its content)
printContainer(container(ID, Content)) :-
	write('Container '), write(ID), write(':'), nl,
	printContent(Content).

% Recursively print the contents of the container
printContent([]).
printContent([Row|Rows]) :- printRow(Row), nl, printContent(Rows).

% Recursively print out a row
printRow([]).
printRow([X|Y]) :- write(X), write(' '), printRow(Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Set a value at Height/Width%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Height and width start counting in lower left corner which is (0,0)

% This one doesn't work yet in one command
setValue(container(ID, Content), Height, Width, Value, container(ID, NewContent)) :-
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
	container(ContainerID, Content),
	Height,
	Width,
	0,
	Value,
	NewContainer
) :-
	setValue(container(ContainerID, Content), Height, Width, Value, NewContainer).

placeHorizontalLineAt(
	container(ContainerID, Content),
	Height,
	Width,
	LineWidth,
	Value,
	NewContainer
) :-
	setValue(container(ContainerID, Content), Height, Width, Value, NC),
	W is Width + 1,
	LW is LineWidth - 1,
	placeHorizontalLineAt(NC, Height, W, LW, Value, NewContainer).

placeObjectAt(
	container(ContainerID, Content),
	object(ObjectID, size(1, ObjectWidth, ObjectDepth)),
	Height,
	Width,
	NewContainer
) :-
	placeHorizontalLineAt(
		container(ContainerID, Content),
		Height,
		Width,
		ObjectWidth,
		ObjectID,
		NewContainer
	).

placeObjectAt(
	container(ContainerID, Content),
	object(ObjectID, size(ObjectHeight, ObjectWidth, ObjectDepth)),
	Height,
	Width,
	NewContainer
) :-
	placeHorizontalLineAt(
		container(ContainerID, Content),
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
