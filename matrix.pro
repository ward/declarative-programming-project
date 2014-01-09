% Matrix stuff

% (X,Y)
% [
%   [ (0,0), (1,0), (2,0) ],
%   [ (0,1), (1,1), (2,1) ],
%   [ (0,2), (1,2), (2,2) ]
% ]

% Check if spots [X, X2[ are Elem
nth0_line(X, X2, List, Elem) :-
	nth0(X, List, Elem),
	X2 is X + 1.
nth0_line(X, X2, List, Elem) :-
	nth0(X, List, Elem),
	X1 is X + 1,
	nth0_line(X1, X2, List, Elem).

% Check if spot (X,Y) in Matrix is Elem
matrix_nth0(X, Y, Matrix, Elem) :-
	nth0(Y, Matrix, R),
	nth0(X, R, Elem).

% Check if block from ([X, X2[, [Y, Y2[) is only Elem
matrix_nth0_block(X, Y, X2, Y2, Matrix, Elem) :-
	nth0(Y, Matrix, Row),
	Y2 is Y + 1,
	nth0_line(X, X2, Row, Elem).
matrix_nth0_block(X, Y, X2, Y2, Matrix, Elem) :-
	nth0(Y, Matrix, Row),
	nth0_line(X, X2, Row, Elem),
	Y1 is Y + 1,
	matrix_nth0_block(X, Y1, X2, Y2, Matrix, Elem).

% Change the value in position X
list_set_at(X, List, Elem, NewList) :-
	nth0(X, List, _, TempList),
	nth0(X, NewList, Elem, TempList).

% Change values in position [X, X2[
list_set_line(X, X, List, _, List).
list_set_line(X, X2, List, Elem, NewList) :-
	list_set_at(X, List, Elem, TempList),
	X1 is X + 1,
	list_set_line(X1, X2, TempList, Elem, NewList).

% Change the value in position (X,Y)
matrix_set_at(X, Y, Matrix, Elem, NewMatrix) :-
	nth0(Y, Matrix, Row),
	list_set_at(X, Row, Elem, NewRow),
	list_set_at(Y, Matrix, NewRow, NewMatrix).

% Change the values in block ([X, X2[, [Y, Y2[)
matrix_set_block(X, Y, X2, Y, Matrix, _, Matrix).
matrix_set_block(X, Y, X2, Y2, Matrix, Elem, NewMatrix) :-
	nth0(Y, Matrix, Row),
	list_set_line(X, X2, Row, Elem, NewRow),
	list_set_at(Y, Matrix, NewRow, TempMatrix),
	Y1 is Y + 1,
	matrix_set_block(X, Y1, X2, Y2, TempMatrix, Elem, NewMatrix).
