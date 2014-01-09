# Declarative Programming Project

## Description

[Full description](https://ai.vub.ac.be/node/1208).

## Software needed

SWI-Prolog version 6.4.1 for i686-linux

## Functional reqs

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
