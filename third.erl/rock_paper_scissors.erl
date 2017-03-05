-module(rock_paper_scissors).
-export([main/0]).

main() ->
	tournament([rock,rock,paper,paper], [rock,paper,scissors,rock]).

beat(rock) -> paper;
beat(paper) -> scissors;
beat(scissors) -> rock.

result(X,X) -> 0;
result(X,Y) -> 
	case beat(X) =:= Y of
		true -> -1;
		_ -> 1
	end.

% tournament(Xs,Ys) -> tournament(fun result/2, 0, Xs, Ys).

% tournament(Combine, Start, [], []) -> 
% 	Start;
% tournament(Combine, Start, [X|Xs], [Y|Ys]) ->
% 	Combine(X,Y) + tournament(Combine, Start, Xs, Ys).

tournament(Play1, Play2) ->
	lists:sum(
		lists:zipwith(fun result/2, Play1, Play2)).

