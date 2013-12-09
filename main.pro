
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

% This one doesn't work yet in one command
setValue(container(ID, Content), Height, Width, Value, container(ID, NewContent)) :-
	setValue_height(Content, Height, Width, Value, NewContent).

setValue_width([X|Y], 0, 0, Value, [Value|Y]).
setValue_width([X|Y], 0, Width, Value, [X|NC]) :-
	W is Width - 1,
	setValue_width(Y, 0, W, Value, NC).

setValue_height([Row|Rows], 0, Width, Value, [NC|Rows]) :-
	setValue_width(Row, 0, Width, Value, NC).
setValue_height([Row|Rows], Height, Width, Value, [Row|NC]) :-
	H is Height - 1,
	setValue_height(Rows, H, Width, Value, NC).