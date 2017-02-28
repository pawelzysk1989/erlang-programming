-module(second).

-export([hypotenuse/2, perimeter/2]).



hypotenuse(X,Y) ->
    math:sqrt(first:square(X) + first:square(Y)).

perimeter(X,Y) ->
    hypotenuse(X,Y) + X + Y.