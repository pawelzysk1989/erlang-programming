-module(w22).
-export([main/0]).

main() ->
    
    io:fwrite("~w~n",[take(0, "hello")]),
    io:fwrite("~s~n",[take(1, "hello")]),
    io:fwrite("~s~n",[take(2, "hello")]),
    io:fwrite("~s~n",[take(3, "hello")]),
    io:fwrite("~s~n",[take(4, "hello")]),
    io:fwrite("~s~n",[take(5, "hello")]),
    io:fwrite("~s~n",[take(6, "hello")]),
    io:fwrite("~s~n",[take(9, "hello")]),
    io:fwrite("~w~n",[nub([2,3,3,1,2,3,2,3,1])]),
    io:fwrite("~w~n",[nub([])]),
    io:fwrite("~w~n",[nub([2,3,3,1,2,3,2,3,1,5,6])]),
    io:fwrite("~w~n",[nub([2,3,3,1,4,3,2,3,1])]),
    io:fwrite("~w~n",[reverse([1,3,4,5,6])]),
    io:fwrite("~w~n",[reverse([])]),
    io:fwrite("~w~n",[reverse([2])]),
    io:fwrite("~s~n",[nopunct("gdfg/gdsfg'hgfh; : gsdg ")]),
    io:fwrite("~w~n",[palindrome("")]),
    io:fwrite("~w~n",[palindrome("l")]),
    io:fwrite("~w~n",[palindrome("Pawel")]),
    io:fwrite("~w~n",[palindrome("kobyla ma maly bok")]),
    io:fwrite("~w~n",[palindrome("Kajak")]),
    io:fwrite("~w~n",[palindrome("Madam I\'m Adam")]).
    io:fwrite("~w~n",[f([2,3,4,5])]).

f([X,Y|Xs]) -> X.



direct take 1
take(0,_) -> [];
take(N,[S|Ss]) ->
  case N>length(Ss)+1 of
      true -> [S|take(length(Ss),Ss)];
      false -> [S|take(N-1,Ss)]
  end.

direct take 2
take(0,_) -> [];
take(N,[S|Ss]) when N>length(Ss)+1 -> [S|take(length(Ss),Ss)];
take(N,[S|Ss]) -> [S|take(N-1,Ss)].


tail take
take(N,Ss) ->
  case N>length(Ss) of
      true -> take(length(Ss),Ss,[]);
      false -> take(N,Ss,[])
  end.

take(0,_,R) -> reverse(R);
take(N,[S|Ss],R) -> take(N-1,Ss,[S|R]).
    
reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

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

%remove all duplicates from the list

nub(Xs) -> nub(sort(Xs),nil).

nub([],_) -> [];
nub([X|Xs], X) -> nub(Xs,X); 
nub([X|Xs], _P) -> [X|nub(Xs,X)]. 

reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

%simple palindrome 1

palin(Xs) ->
    Xs == reverse(Xs).

simple palindrome 2
palin(Xs) -> palin(Xs,reverse(Xs)).

palin([],[]) -> true;
palin([X|Ls],[X|Rs]) -> palin(Ls,Rs);
palin([_X|_Ls],[_Y|_Rs]) -> false.

palindrome(Xs) -> palin(nopunct(nocaps(Xs))).

nocaps([]) -> [];
nocaps([X|Xs]) ->
    case X >= $A andalso X =< $Z of
        true -> [X+32|nocaps(Xs)];
        false -> [X|nocaps(Xs)]
    end.

nopunct([]) -> [];
nopunct([X|Xs]) ->
    case lists:member(X,"./,\\ ;:\t\n\'\"")  of
        true -> nopunct(Xs);
        false -> [X|nopunct(Xs)]
    end.

