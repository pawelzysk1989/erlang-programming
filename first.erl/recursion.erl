-module(recursion).

-export([fib1/1, fib2/1, perfNumber/1, fib/1]).

%direct fibonacci
fib1(0) -> 0;
fib1(1) -> 1;
fib1(N) ->
    fib1(N-1) + fib1(N-2).

%tail fibonacci
fib2(N)->
    fib2(N, 0, 1).

fib2(0, P1, _P2) ->
    P1;
fib2(N, P1, P2) when N > 0 ->
    fib2(N-1, P2, P1+P2).

%pattern fibonacci
fibP(0)->
    {0, 1};

fibP(N) ->
    {P, C} = fibP(N-1),
    {C, P + C}.

fib(N) ->
    {C, _P} = fibP(N),
    C.

%tail perfNumber
perfNumber(N)->
    perfNumber(N, 1, 0).

perfNumber(N, N, S) ->
    N == S;
perfNumber(N, I, S) when N rem I == 0 ->
    perfNumber(N, I+1, S+I);
perfNumber(N, I, S) ->
    perfNumber(N, I+1, S).

