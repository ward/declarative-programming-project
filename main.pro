
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


% Prints container (header + its content)
printContainer(container(X, Y)) :- write('Container '), write(X), write(':'), nl, printContent(Y).

% Recursively print the contents of the container
printContent([]).
printContent([X|Y]) :- printRow(X), nl, printContent(Y).

% Recursively print out a row
printRow([]).
printRow([X|Y]) :- write(X), write(' '), printRow(Y).