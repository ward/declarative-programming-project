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
% Cut to make sure that when handling a 0, the clause after doesn't trigger as
% well.
printRow([0|Y]) :- write(' . '), printRow(Y), !.
printRow([X|Y]) :- format('~|~` t~d~2+', X), write(' '), printRow(Y).
