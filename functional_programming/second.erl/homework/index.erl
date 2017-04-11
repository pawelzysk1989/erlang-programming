-module(index).
-export([search/2]).

search(FileName, ListOfSearchedWords) ->
    ListOfLines = read:get_file_contents(FileName),
    SortedListOfWordsWithIndexes = lists:sort(fun(X,Y) -> X<Y end, removeShortWords(indexLines(ListOfLines,1))),
    erlang:display(searchForWords(ListOfSearchedWords, SortedListOfWordsWithIndexes)).

%Searching functions
%----------------------------------------------

%returns tuples with the range of lines where the word was found ex. [{7,7}, {12,15},{22,23}]
%input: W -searched word, Xs - SORTED list of tuples with the word and number of the word occurence ex[.., {"foo",2}]
searchForWord(W,Xs) -> searchForWord(W,Xs,{0,0},[],false).

% last element of the list was the searched element
searchForWord(_,[],P,R,true) -> 
	reverse([P|R]);
% nothing was found
searchForWord(_,[],_,_,false) -> [];
% searched word was found
searchForWord(W,[{W,N}|Xs],_,R,false) -> 
	searchForWord(W,Xs,{N,N},R,true); 
% ommiting when searched word found on the same line as the previous one
searchForWord(W,[{W,N}|Xs],{_,N}=P,R,true) -> 
	searchForWord(W,Xs,P,R,true); 
% when searched word found on the line below as the previous one
searchForWord(W,[{W,N}|Xs],{N1,N2},R,true) when N-N2=:=1 -> 
	searchForWord(W,Xs,{N1,N},R,true); 
% when searched word found at least two lines below as the previous one
searchForWord(W,[{W,N}|Xs],{N1,N2},R,true) -> 
	searchForWord(W,Xs,{N,N},[{N1,N2}|R],true); 
% when searched word was not yet found
searchForWord(W,[{_,_}|Xs],P,R,false) -> 
	searchForWord(W,Xs,P,R,false); 
% stop searching because the new word was found after searched word
searchForWord(_W,[{_X,_}|_],P,R,true) -> 
	reverse([P|R]).


searchForWords([],_) -> [];
searchForWords([X|Xs],L) ->
	[{X, searchForWord(X,L)}] ++ searchForWords(Xs,L).

%----------------------------------------------

% returns: list of strings 
% input: string, string of separators ex. " ;:\""
splitString(Xs,S) -> reverse(splitString(Xs,S,"",[],false)).

splitString([],_S,_W,R,false) -> R;
splitString([],_S,W,R,true) -> [reverse(W)|R];
splitString([L|Ls],S,W,R,false) -> 
	case member(L,S) of
 		true -> splitString(Ls,S,W,R,false);
 		false -> splitString(Ls,S,[nocaps(L)],R,true)
 	end;
splitString([L|Ls],S,W,R,true) -> 
	case member(L,S) of
 		true -> splitString(Ls,S,"", [reverse(W)|R],false);
 		false -> splitString(Ls,S,[nocaps(L)|W],R,true)
 	end.

% returns: list of tuples {string, number of line that string occured} ex. [...,{"foo", 5}, ...]
% input: list of string, number from which counting starts
indexLines([],_) ->[];
indexLines([L|Ls],N) ->
	indexWords(splitString(L,"`()<>[]-./,\\ ;:\t\n\'\""),N) ++ indexLines(Ls,N+1).

% returns: list of tuples {string, number of line that string occured} ex. [...,{"foo", 5}, ...]
% input: list of string, number of line of string
indexWords([],_) -> [];
indexWords([X|Xs],N) ->
	[{X,N}|indexWords(Xs,N)].

%helper functions
%----------------------------------------------
member(_Y,[]) -> false;
member(X,[X|_Xs]) -> true;
member(Y,[_X|Xs]) -> member(Y,Xs).

reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

nocaps(X) ->
    case X >= $A andalso X =< $Z of
        true -> X+32;
        false -> X
    end.

removeShortWords([]) -> [];
removeShortWords([{W,_}|Xs]) when length(W) < 3 -> removeShortWords(Xs);
removeShortWords([X|Xs]) -> [X|removeShortWords(Xs)].

%----------------------------------------------
