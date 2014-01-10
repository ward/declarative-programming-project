% TODO: Implicitly relies on matrix.pro to be loaded first

% Count how many empty spots there still are in the given container
container_empty_spots(container(_, size(CH, CW, CD), Content), N) :-
	CV is CH * CW * CD,
	findall([X,Y], matrix_nth0(X, Y, Content, 0), Freespots),
	length(Freespots, Fn),
	N is CV - Fn.

% Place object at a certain spot in the container, uses the matrix functions.
placeObjectAt(
	container(ContainerID, size(CH, CW, CD), Content),
	object(ObjectID, size(ObjectHeight, ObjectWidth, ObjectDepth)),
	Height,
	Width,
	container(ContainerID, size(CH, CW, CD), NewContent)
) :-
	H2 is Height + ObjectHeight,
	W2 is Width  + ObjectWidth ,
	matrix_set_block(Width, Height, W2, H2, Content, ObjectID, NewContent).

% Easily bind a container. Call it with for example container(1, C). Now C is
% the container with ID 1.
container(N, Container) :-
	findall(container(ID, Size, Content), container(ID, Size, Content), List),
	nth1(N, List, Container).


% List is output, contains all containers
allContainers(List) :- findall(container(ID, Size, Content), container(ID, Size, Content), List).
