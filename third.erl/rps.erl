-module(rps).
-export([play/1,echo/1,play_two/3,rock/1,no_repeat/1,const/1,enum/1,cycle/1,rand/1,val/1,tournament/2]).


%
% play one strategy against another, for N moves.
%

play_two(StrategyL,StrategyR,N) ->
    play_two(StrategyL,StrategyR,[],[],N).

% tail recursive loop for play_two/3
% 0 case computes the result of the tournament

% FOR YOU TO DEFINE
% REPLACE THE dummy DEFINITIONS

play_two(_,_,PlaysL,PlaysR,0) ->
    io:format("Total result: ~p~n",[tournament(PlaysL,PlaysR)]);

play_two(StrategyL,StrategyR,PlaysL,PlaysR,N) ->
    PlayL=StrategyL(PlaysL),
    PlayR=StrategyR(PlaysR),
    io:format("Player L: ~p, Player R: ~p, Result: ~p~n",[PlayL, PlayR, result(PlayL,PlayR)]),
    play_two(StrategyL,StrategyR,[PlayL|PlaysL],[PlayR|PlaysR],N-1).

%
% interactively play against a strategy, provided as argument.
%

play(Strategy) ->
    io:format("Rock - paper - scissors~n"),
    io:format("Play one of rock, paper, scissors, ...~n"),
    io:format("... r, p, s, stop, followed by '.'~n"),
    play(Strategy,[],[]).

% tail recursive loop for play/1

play(Strategy,YourPlays,CpuPlays) ->
    {ok,P} = io:read("Play: "),
    Play = expand(P),
    case Play of
    	stop ->
            io:format("Total result: ~p~n",[tournament(YourPlays,CpuPlays)]),
    	    io:format("Stopped~n");
    	_    ->
            CpuPlay=Strategy(CpuPlays),
    	    io:format("Your play: ~p, CPU play: ~p, Result: ~p~n",[Play, CpuPlay, result(Play,CpuPlay)]),
    	    play(Strategy,[Play|YourPlays],[CpuPlay|CpuPlays])
    end.

%
% auxiliary functions
%

% transform shorthand atoms to expanded form
    
expand(r) -> rock;
expand(p) -> paper;		    
expand(s) -> scissors;
expand(X) -> X.

% result of one set of plays

result(rock,rock) -> draw;
result(rock,paper) -> lose;
result(rock,scissors) -> win;
result(paper,rock) -> win;
result(paper,paper) -> draw;
result(paper,scissors) -> lose;
result(scissors,rock) -> lose;
result(scissors,paper) -> win;
result(scissors,scissors) -> draw.

% result of a tournament

tournament(PlaysL,PlaysR) ->
    lists:sum(
      lists:map(fun outcome/1,
		lists:zipwith(fun result/2,PlaysL,PlaysR))).

outcome(win)  ->  1;
outcome(lose) -> -1;
outcome(draw) ->  0.

% transform 0, 1, 2 to rock, paper, scissors and vice versa.

enum(0) ->
    rock;
enum(1) ->
    paper;
enum(2) ->
    scissors.

val(rock) ->
    0;
val(paper) ->
    1;
val(scissors) ->
    2.

% give the play which the argument beats.

beats(rock) ->
    scissors;
beats(paper) ->
    rock;
beats(scissors) ->
    paper.

%
% strategies.
%
echo([]) ->
     paper;
echo([Last|_]) ->
    Last.

rock(_) ->
    rock.


% FOR YOU TO DEFINE
% REPLACE THE dummy DEFINITIONS

no_repeat([]) ->
    rand(wathever);
no_repeat([X|_]=Xs) ->
    case R=rand(wathever) of
        X -> no_repeat(Xs);
        _ -> R
    end.

const(Play) ->
    dummy.

cycle([]) ->
    rand(wathever);
cycle([X|Xs]) ->
    case X of
        rock -> paper;
        paper -> scissors;
        scissors -> rock
    end.


rand(_) ->
    enum(random:uniform(3)-1).
