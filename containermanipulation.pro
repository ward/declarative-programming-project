% TODO: Implicitly relies on matrix.pro to be loaded first

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
