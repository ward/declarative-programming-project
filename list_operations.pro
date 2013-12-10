% Some list stuff

% true if Value occurs Amount times in the list
occursInList([], _, 0).
occursInList([Value|Xs], Value, Amount) :-
	occursInList(Xs, Value, A),
	Amount is A + 1.
occursInList([X|Xs], Value, Amount) :-
	X \= Value,
	occursInList(Xs, Value, Amount).

sequenceInList([], 0, _, 0).
sequenceInList([X|Xs], 0, _, 0).
%sequenceInList([Value|Xs], 0, Value, 1).
sequenceInList([Value|Xs], 0, Value, Length) :-
	sequenceInList(Xs, 0, Value, L),
	Length is L + 1.
sequenceInList([X|Xs], 0, Value, Length) :-
	X \= Value, fail.
sequenceInList([X|Xs], StartPosition, Value, Length) :-
	SP is StartPosition - 1,
	sequenceInList(Xs, SP, Value, Length).
