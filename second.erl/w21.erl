-module(fissbuzz).
-export([main/0]).

main() ->
    io:fwrite("~w~n",[indexOfMax([3,4,1,4,1,5,5,2,3,2,5])]),
    io:fwrite("~w~n",[mode([3,4,1,4,1,5,5,2,3,2,5])]),
    io:fwrite("~w~n",[median([5,2,4,3,1])]),
    io:fwrite("~w~n",[sort([54,26,93,17,77,31,44,55,20])]),
    io:fwrite("~w~n",[evans([1,2,3,4,5,6])]),
    io:fwrite("~w~n",[sum([1,2,3,4,5])]),
    io:fwrite("~w~n",[double([1,2,3,4,5])]),
    io:fwrite("~w~n",[tailDouble([1,2,3,4,5])]).

sum(Xs) -> sum(Xs, 0).
sum([],S) -> S;
sum([X|Xs],S) -> sum(Xs,S+X).    

double([]) -> [];
double([X|Xs]) -> [2*X|double(Xs)].

tailDouble(Xs) -> tailDouble(Xs, []).
tailDouble([],R) -> reverse(R);
tailDouble([X|Xs],R) -> tailDouble(Xs,[2*X|R]).

reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

evans([]) -> [];
evans([X|Xs]) -> 
	case X rem 2 of
		0 -> [X|evans(Xs)];
		_ -> evans(Xs)
	end.

sort([]) -> [];
sort([X|Xs]) -> 
	{L,P} =partition(X,Xs),
	sort(L) ++ [X] ++ sort(P).

partition(N,Ys) -> partition(N,Ys,[],[]).
partition(_N,[],L,R) -> {L,R};
partition(N,[Y|Ys],L,R) -> 
	case Y>N of
		true -> partition(N,Ys,L,[Y|R]); 
		false -> partition(N,Ys,[Y|L],R) 
	end.

median(Xs) ->
	S=sort(Xs),
	L=length(S),
	case L rem 2 of
		0 -> (lists:nth(L div 2, S) + lists:nth(L div 2 + 1, S))/2;
		_ -> lists:nth(L div 2 + 1, S)
	end.


mode(Xs) -> 
	Sorted=sort(Xs),
	lists:nth(indexOfMax(modeList(Sorted))-1, Sorted).

modeList(Xs) -> modeList(Xs, {nil,-1}).

modeList([], _P) -> [];
modeList([X|Xs], {P,Pc}) ->
	case X == P of
		true -> [Pc+1|modeList(Xs,{X,Pc+1})];
		false -> [1|modeList(Xs,{X,1})]
	end.

indexOfMax([X|Xs]) -> indexOfMax(Xs,X,0,0).

indexOfMax([],_M,_I,Mi) -> Mi;
indexOfMax([X|Xs],M,I,Mi) -> 
	case X>M of
		true -> indexOfMax(Xs,X,I+1,I+1);
		false -> indexOfMax(Xs,M,I+1,Mi)
	end.
