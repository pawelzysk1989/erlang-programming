-module(w222).
-export([main/0]).

main() ->
    % io:fwrite("~s~n",[join("hel","lo")]),
    % io:fwrite("~s~n",[concat(["goo","d","","by","e"])]),
    % io:fwrite("~s~n",[member(2,[2,0,0,1])]),
    % io:fwrite("~s~n",[member(20,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(0,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(1,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(2,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(3,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(4,[2,0,0,1])]),
    % io:fwrite("~w~n",[split(0,[])]),
    % io:fwrite("~w~n",[merge([1,3,5,12],[2,4,6,9])]),
    %io:fwrite("~w~n",[mergeSort([2,45,23,6,1,4,3,9,6,7,8,4])]),
    % io:fwrite("~w~n",[partition(8,[2,45,23,6,1,4,3,9,6,7,8,4])]),
    % io:fwrite("~w~n",[partition(8,[2,6,1,4,3,6,7,8,4])]),
    % io:fwrite("~w~n",[partition(8,[])]),
    % io:fwrite("~w~n",[partition(8,[13])]),
    % io:fwrite("~w~n",[quickSort([2,45,23,6,1,4,3,9,6,7,8,4])]),
    io:fwrite("~w~n",[perm([1,2,3])]).

perm([]) -> [[]];
perm(L) -> [ [X|Y] || X<-L, Y<-perm(L--[X]) ].

% join([],[]) -> [];
% join([],[Y|Ys]) -> 
%     [Y|join([],Ys)];
% join([X|Xs],Ys) ->
%     [X|join(Xs,Ys)].

% concat([]) -> [];
% concat([X|Xs]) ->
%     join(X,concat(Xs)).

% partition(N,Xs) -> partition(N,Xs,[],[]).

% partition(_N,[],L,P) -> {L,P};
% partition(N,[X|Xs],L,P) when X>N -> partition(N,Xs,L,[X|P]);
% partition(N,[X|Xs],L,P) -> partition(N,Xs,[X|L],P).

% quickSort([]) -> [];
% quickSort([X|Xs]) ->
%     {L,P} = partition(X,Xs),
%     concat([quickSort(L),[X],quickSort(P)]).

% mergeSort([]) -> [];
% mergeSort([X]) -> [X];
% mergeSort(Xs) ->
%     {L,P} = split(length(Xs) div 2, Xs),
%     merge(mergeSort(L), mergeSort(P)).

% merge([],[]) -> [];
% merge([],[P|Ps]) -> [P|merge([],Ps)];
% merge([L|Ls],[]) -> [L|merge(Ls,[])];
% merge([L|Ls],[P|Ps]) ->
%     case L =< P of
%         true -> [L|merge(Ls,[P|Ps])];
%         false -> [P|merge([L|Ls],Ps)]
%     end.

% split(N,Xs) -> split(N,Xs,[]).
% split(0,Ps,Ls) -> {reverse(Ls),Ps};
% split(N,[X|Xs],Ls) ->
%     split(N-1,Xs,[X|Ls]).

% reverse(Xs) -> reverse(Xs, []).
% reverse([],R) -> R;
% reverse([X|Xs],R) -> reverse(Xs, [X|R]).

% member(_N,[]) -> false;
% member(X,[X|_Xs]) -> true;
% member(N,[_X|Xs]) -> member(N,Xs).


