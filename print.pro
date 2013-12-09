% Prints container (header + its content)
printContainer(container(ID, size(H, W, D), Content)) :-
	write('Container '), write(ID), write(':'), nl,
	printContent(Content).

% Recursively print the contents of the container
printContent([]).
printContent([Row|Rows]) :- printContent(Rows), nl, printRow(Row).

% Recursively print out a row
printRow([]).
printRow([X|Y]) :- write(X), write(' '), printRow(Y).