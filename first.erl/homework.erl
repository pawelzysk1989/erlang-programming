-module(homework).

-export([directBits/1, tailBits/1]).

%direct recursion bit sum
directBits(0) -> 0;
directBits(N) ->
    N rem 2 + directBits(N div 2).

%tail recursion bit sum
tailBits(N) ->
    tailBits(N, 0).

tailBits(0, R) ->
    R;
tailBits(N, R) ->
    tailBits(N div 2, R + N rem 2).



