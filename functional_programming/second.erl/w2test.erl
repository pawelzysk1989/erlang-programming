-module(w2test).
-export([main/0]).

main() ->

    % io:fwrite("~w~n",[ [f1(A,B) || A <- [true,false], B <- [true,false]] ]),
    % io:fwrite("~w~n",[ [f2(A,B) || A <- [true,false], B <- [true,false]] ]),
    % io:fwrite("~w~n",[ [f3(A,B) || A <- [true,false], B <- [true,false]] ]),
    % io:fwrite("~w~n",[ [f4(A,B) || A <- [true,false], B <- [true,false]] ]),
    % io:fwrite("~w~n",[ square(3,4) ]),
    % foo(0,[4,0,1]),
    % bar(4,[1,2,3,4,5,6]),
    length({1,2,3,4,true}).
    

%1
% f1(A,B) -> (not(A) or not(B)).
% f2(A,B) -> not(A and B).
% f3(A,B) -> not(A andalso B).
% f4(A,B) -> (not(A) and B) or (not(B) and A).

%4
% square(X,Y) ->
%     false;
% square(X,X) ->
%     true.

%5
% merge([],Ys) -> Ys;
% merge(Xs,[]) -> Xs;
% merge([X|Xs],[Y|Ys]) when X<Y ->
%     [ X | merge(Xs,[Y|Ys]) ];
% merge([X|Xs],[Y|Ys]) when X>Y ->
%     [ Y | merge([X|Xs],Ys) ];
% merge([X|Xs],[Y|Ys]) ->
%     [ X | merge(Xs,Ys) ].

%6
% foo(_,[])              -> [];
% foo(Y,[X|_]) when X==Y -> [X];
% foo(Y,[X|Xs])          -> [X | foo(Y,Xs) ].

%7
% bar (N, [Y]) ->
%     [Y];
% bar (N, [N]) ->
%     [];
% bar (N, [Y|Ys]) when N =/= Y ->
%     [Y|bar (N, Ys)];
% bar (N, [Y|Ys]) ->
%     Ys.

%8
% baz([])     -> [];
% baz([X|Xs]) -> [X | baz(zab(X,Xs))].

% zab(N,[])     -> [];
% zab(N,[N|Xs]) -> zab(N,Xs);
% zab(N,[X|Xs]) -> [X | zab(N,Xs)].













