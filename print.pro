% Prints container (header + its content)
printContainer(container(ID, size(H, W, D), Content)) :-
	write('Container '), write(ID),
	write(' ('), write(H), write('x'), write(W), write('x'), write(D), write(')'), nl,
	printContent(Content).

% Recursively print the contents of the container
printContent([]).
printContent([Row|Rows]) :- printContent(Rows), printRow(Row).

% Recursively print out a row
printRow([]) :- nl.
printRow([X|Y]) :- write(X), write(' '), printRow(Y).