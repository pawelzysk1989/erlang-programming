-module(hof).
-export([main/0]).

main() ->
	% variables as functions
	Add = fun (X,Y) -> X+Y end,
	Sum = fun (Xs) -> lists:foldr(Add,0,Xs) end,
	Sum([1,2,3,4,5]),
	% fun expressions with pattern matching 
	EmptyTest = fun ([]) -> true ; ([_|_]) -> false end,
	EmptyTest([3]),
	% fun expressions can be recursive
	Foo = fun Product([]) -> 1 ; Product([X|Xs]) -> X*Product(Xs) end,
	Foo([10,1,2]),
	Twice = twice(fun(X) -> X*3 end),
	Twice(2),
	addToAll(4, [1,2,3,4,5]),
	((iterate(0))(fun(X) -> X+20 end))(1).



add(X) ->
    fun(Y) -> X+Y end.

addToAll(N,Xs) ->
	lists:map(add(N),Xs).

times(X) ->
    fun(Y) ->
	     X*Y end.

compose(F,G) ->
    fun(X) -> G(F(X)) end.

twice(F) ->
	compose(F, F).

id(X) -> X.

iterate(0) ->
	fun(_F) -> fun id/1 end;
iterate(N) ->
	fun(F) ->
		compose(F,(iterate(N-1))(F)) end.

% iterate(0) -> fun id/1;
% iterate(N) when N > 0 ->
%     fun(Fn) ->
%         lists:foldl(fun compose/2, fun id/1, lists:duplicate(N, Fn))
%     end.


      
	     

