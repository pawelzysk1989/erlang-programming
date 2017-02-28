-module(fissbuzz).
-export([main/0]).

main() ->
    io:fwrite("~w~n",[zip([1,3,5,7], [2,4])]).

zip_with(_,[],_) -> [];
zip_with(_,_,[]) -> [];
zip_with(F,[X|Xs],[Y|Ys]) ->
 	[F(X,Y)| zip_with(F,Xs,Ys)].

zip(Xs,Ys) -> zip_with(fun(X,Y) -> {X,Y} end,Xs,Ys).

% zip([],_) -> [];
% zip(_,[]) -> [];
% zip([X|Xs],[Y|Ys]) ->
% 	[{X,Y}|zip(Xs,Ys)].

% zip_with(F,Xs,Ys) -> lists:map(fun({A,B}) -> F(A,B) end,zip(Xs,Ys)).

%doubleAll(Xs) -> lists:map(fun(X) -> X*2 end,Xs).

% doubleAll(Xs) -> lists:map(fun double/1,Xs).

% double(X) -> 2*X.


%evens(Xs) -> lists:filter(fun(X) -> X rem 2 =:= 0 end, Xs).

% evens(Xs) -> lists:filter(fun isEven/1, Xs).

% isEven(X) -> 
% 	X rem 2 =:= 0.

%product(Xs) -> lists:foldr(fun(X,Y) -> X*Y end,1,Xs).

% product(Xs) -> lists:foldr(fun prod/2,1,Xs).

% prod(X,Y) -> X*Y.


