# Declarative Programming Project

## Description

[Full description](https://ai.vub.ac.be/node/1208).

Given a list of objects, place them in two containers in (a) optimal way(s).

## Software needed

SWI-Prolog version 6.4.1 for i686-linux

## Overview

At first an attempt was made to find only ideal solutions. It quickly became
clear how unfeasible this was. Without having a good algorithm at our disposal,
it just comes down to bruteforcing over a ridiculously high amount of
combinations.

Instead was opted for a good enough solution. The idea is to first sort the
given objects from biggest volume to smallest volume. Next we go through the
list, each time trying to add the object to the container that is
emptiest/lightest at that moment. When adding an object it is always placed as
low and as left in the grid as possible. This assures, at the very least, that
no object will be *completely* floating in the air. If a point is reached that
the object does not fit in the container, then this object is set aside and the
algorithm continues with the rest of the objects.

In most of the cases, this will give a decent solution to the problem. Decent in
the sense that it comes close to a most balanced, least unused spaces as well as
most used objects solution. The chance of putting a heavier object on top of a
lighter one is also heavily reduced, but not eliminated, by the order we use to
go through the objects.

## Detailed

### Container and Object

The project has two major data structures around which everything resolves. On
the one hand there are the objects, as provided in the project description. An
object is of this form.

    object(ID, size(Height, Length, Depth)).

Throughout the project it is assumed `Depth = 1`.

The other structure is, obviously, a container. These are of the form

    container(ID, size(Height, Length, Depth), Matrix).

Here too `Depth = 1` at all times. The `Matrix` part is a list of lists in
accordance with the `Height` and `Length` mentioned in `size`. For example if
`Height` would be 2 and `Width` would be 3, then the `Matrix` would be of the
form

    [
        [0,0,0],
        [0,0,0]
    ]

The number 0 is used as the default value. When an object gets added into a
container, the appropriate values in the matrix get changed to the object's
`ID`.

### Matrix

Since we essentially keep track of the state of a container by using a matrix,
it was deemed appropriate to write some functions that handle matrices in ways
that will be useful.

The concepts deemed appropriate were on the one hand variants of `nth0/3` (one
for the value in a matrix, one for the value of a range in a list, one for the
values of a block in a matrix) and on the other hand functions that take a list
or matrix and change the value (or a range or block of values) on a certain
spot.

### all

Prints out every possibility on the screen. Every possiblity here means that
given a set of objects, split the set of objects in every way without being
redundant. By this is meant that the following splits of a list `[1,2,3]` are
all equal.

    [1]   [2,3]
    [1]   [3,2]
    [2,3] [1]
    [3,2] [1]

Next, given a certain split up of the set into `O1` and `O2`, try all
arrangements of `O1` into the first container and all arrangements of `O2` in
the second container. Here the criteria are that every object is placed as low
as possible and as left as possible.

This is run by issuing `all.`. Every press of `;` gives a new solution. Keep in
mind that the amount of possibilities quickly becomes *enormous*. Testing it is
adviced to be done in small amounts of objects, if you want it to ever finish.
