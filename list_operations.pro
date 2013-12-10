% Some list stuff

% Checks in an array
%% isRow([], _, _, 0) :- !.
%% isRow([], _, _, Length) :- fail.
%% isRow([Value|Xs], 0, Value, Length) :-
%% 	L is Length - 1,
%% 	isRow(Xs, 0, Value, L).
%% isRow([X|Xs], 0, Value, Length) :-
%% 	X \= Value, fail.
%% isRow([X|Xs], StartPosition, Value, Length) :-
%% 	SP is StartPosition - 1,
%% 	isRow(Xs, SP, Value, Length).

occursInList([], _, 0).
occursInList([Value|Xs], Value, Amount) :-
	occursInList(Xs, Value, A),
	Amount is A + 1.
occursInList([X|Xs], Value, Amount) :-
	X \= Value,
	occursInList(Xs, Value, Amount).
