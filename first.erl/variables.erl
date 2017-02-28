-module(variables).

-export([howManyEqual/3, maxThree/3]).

howManyEqual(X,X,X) ->
    3;
howManyEqual(X,X,_) ->
    2;
howManyEqual(X,_,X) ->
    2;
howManyEqual(_,X,X) ->
    2;
howManyEqual(_,_,_) ->
    0.

getBigger(X,Y) ->
    case X>Y of
        true -> X;
        false -> Y
    end.

maxThree(X,Y,Z) ->
    getBigger(getBigger(X,Y), Z).