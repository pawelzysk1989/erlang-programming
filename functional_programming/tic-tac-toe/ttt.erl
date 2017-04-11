-module(ttt).
-export([main/0]).
-include_lib("eunit/include/eunit.hrl").

main() ->
	InitialBoard = initial_board(),
	print_board(InitialBoard),
	play(initial_board()).

is_field_available([],_) -> false;
is_field_available([{X,Y,empty}|_Rest],{X,Y}) -> true;
is_field_available([_|Rest],Coor) ->
	is_field_available(Rest,Coor).

your_move(Board) ->
	{ok,X} = io:read("X: "),
	{ok,Y} = io:read("Y: "),
	case is_field_available(Board, {X,Y}) of
		true -> {X,Y};
		false -> 
			io:format("Incorrect coordinates. Try again~n"),
			your_move(Board)
	end.

print_winner(Player)->
	io:format("~p has won~n",[Player]).

play(Board) -> play(Board,cpu).

play(Board,Player) -> 
	case Player of
		user -> {X,Y} = your_move(Board);
		cpu -> {X,Y,_} = min_max2(Board,cpu)
	end,
	UpdatedBoard=update_board(Board,{X,Y,Player}),
	print_board(UpdatedBoard),
	case {has_won(Player,simplify_board(UpdatedBoard)),board_is_full(UpdatedBoard)} of
		{true,_} -> print_winner(Player);
		{false,true} -> io:format("Draw~n");
		{_,_} when Player =:= user -> play(UpdatedBoard,cpu);
		_ -> play(UpdatedBoard,user)
	end.

print_board([]) -> io:format("-----------------------~n");
print_board([{_,_,A},{_,_,B},{_,_,C}|Rest]) ->
	io:format("~p...~p...~p~n",[A,B,C]),
	print_board(Rest).

initial_board() ->
	[
		{1,1,empty},{1,2,empty},{1,3,empty},
		{2,1,empty},{2,2,empty},{2,3,empty},
		{3,1,empty},{3,2,empty},{3,3,empty}
	].

has_won(Player, [Player,Player,Player,_,_,_,_,_,_]) -> true;
has_won(Player, [_,_,_,Player,Player,Player,_,_,_]) -> true;
has_won(Player, [_,_,_,_,_,_,Player,Player,Player]) -> true;
has_won(Player, [Player,_,_,Player,_,_,Player,_,_]) -> true;
has_won(Player, [_,Player,_,_,Player,_,_,Player,_]) -> true;
has_won(Player, [_,_,Player,_,_,Player,_,_,Player]) -> true;
has_won(Player, [Player,_,_,_,Player,_,_,_,Player]) -> true;
has_won(Player, [_,_,Player,_,Player,_,Player,_,_]) -> true;
has_won(_Player, [_,_,_,_,_,_,_,_,_]) -> false.

board_is_full([]) -> true;
board_is_full([{_X,_Y,empty}|_Rest]) -> false;
board_is_full([{_X,_Y,_S}|Rest]) -> board_is_full(Rest).

simplify_board([]) -> [];
simplify_board([{_X,_Y,S}|Rest]) -> [S|simplify_board(Rest)].

update_board([],_) -> [];
update_board([{X,Y,empty}|Rest],{X,Y,Player}) ->
	[{X,Y,Player}|Rest];
update_board([Field|Rest],PlayerMove) ->
	[Field|update_board(Rest,PlayerMove)].

min_max(Board,Player) -> min_max(Board,Board,Player).

min_max([],Board,Player) ->
	case board_is_full(Board) of
		true -> 0;
		false when Player == cpu -> -1000;
		_ -> 1000
	end;
min_max([{X,Y,empty}|Rest],Board,cpu) ->
	UpdatedBoard = update_board(Board,{X,Y,cpu}),
	case has_won(cpu, simplify_board(UpdatedBoard)) of
		true -> 10;
		false -> max(min_max(UpdatedBoard,UpdatedBoard,user),min_max(Rest,Board,cpu))
	end;
min_max([{X,Y,empty}|Rest],Board,user) ->
	UpdatedBoard = update_board(Board,{X,Y,user}),
	case has_won(user, simplify_board(UpdatedBoard)) of
		true -> -10;
		false -> min(min_max(UpdatedBoard,UpdatedBoard,cpu),min_max(Rest,Board,user))
	end;
min_max([_|Rest],Board,Player) ->
	min_max(Rest,Board,Player).

min_max2(Board,Player) -> min_max2(Board,Board,Player).

min_max2([],Board,Player) ->
	case board_is_full(Board) of
		true -> {0,0,0};
		false when Player == cpu -> {0,0,-1000};
		_ -> {0,0,1000}
	end;
min_max2([{X,Y,empty}|Rest],Board,cpu) ->
	UpdatedBoard = update_board(Board,{X,Y,cpu}),
	case has_won(cpu, simplify_board(UpdatedBoard)) of
		true -> {X,Y,10};
		false -> 
			{_,_,Rp} = min_max2(UpdatedBoard,UpdatedBoard,user),
			{Xn,Yn,Rn} = min_max2(Rest,Board,cpu),
			choose_better_move({X,Y,Rp},{Xn,Yn,Rn},cpu)
	end;
min_max2([{X,Y,empty}|Rest],Board,user) ->
	UpdatedBoard = update_board(Board,{X,Y,user}),
	case has_won(user, simplify_board(UpdatedBoard)) of
		true -> {X,Y,-10};
		false -> 
			{_,_,Rp} = min_max2(UpdatedBoard,UpdatedBoard,cpu),
			{Xn,Yn,Rn} = min_max2(Rest,Board,user),
			choose_better_move({X,Y,Rp},{Xn,Yn,Rn},user)
	end;
min_max2([_|Rest],Board,Player) ->
	min_max2(Rest,Board,Player).

choose_better_move({_X,_Y,Rp}=L,{_Xn,_Yn,Rn}=P,Player) ->
	case {Player,Rp>=Rn} of
		{cpu,true} -> L;
		{cpu,_} -> P;
		{user,true} -> P;
		_ -> L
	end.


%tests
full_board() ->
	[
		{1,1,cpu},{1,2,user},{1,3,cpu},
		{2,1,cpu},{2,2,user},{2,3,user},
		{3,1,user},{3,2,cpu},{3,3,user}
	].
board_is_full_1_test() -> ?assertEqual(board_is_full(initial_board()), false).
board_is_full_2_test() -> ?assertEqual(board_is_full(full_board()), true).

simplify_board_1_test() -> ?assertEqual(simplify_board(initial_board()), [empty,empty,empty,empty,empty,empty,empty,empty,empty]).
simplify_board_2_test() -> ?assertEqual(simplify_board(full_board()), [cpu,user,cpu,cpu,user,user,user,cpu,user]).

has_won_1_test() -> ?assertEqual(has_won(cpu, simplify_board(initial_board())), false).
has_won_2_test() -> ?assertEqual(has_won(cpu, simplify_board(full_board())), false).
has_won_3_test() -> ?assertEqual(has_won(cpu, [cpu,user,cpu,cpu,user,user,cpu,cpu,user]), true).
has_won_4_test() -> ?assertEqual(has_won(user, [user,cpu,cpu,cpu,user,user,cpu,cpu,user]), true).

update_board_1_test() -> ?assertEqual(simplify_board(update_board(initial_board(),{1,3,user})), [empty,empty,user,empty,empty,empty,empty,empty,empty]).
update_board_2_test() -> ?assertEqual(simplify_board(update_board(initial_board(),{3,2,cpu})), [empty,empty,empty,empty,empty,empty,empty,cpu,empty]).
update_board_3_test() -> ?assertEqual(simplify_board(update_board(full_board(),{1,3,user})), [cpu,user,cpu,cpu,user,user,user,cpu,user]).

board1() ->
	[
		{1,1,cpu},{1,2,empty},{1,3,cpu},
		{2,1,empty},{2,2,user},{2,3,empty},
		{3,1,cpu},{3,2,empty},{3,3,user}
	].

min_max_1_test() -> ?assertEqual(min_max(board1(),user), 10).

board2() ->
	[
		{1,1,empty},{1,2,empty},{1,3,cpu},
		{2,1,empty},{2,2,user},{2,3,empty},
		{3,1,cpu},{3,2,empty},{3,3,user}
	].

min_max_2_test() -> ?assertEqual(min_max(board2(),cpu), 10).
min_max_3_test() -> ?assertEqual(min_max(board2(),user), -10).

board3() ->
	[
		{1,1,user},{1,2,user},{1,3,cpu},
		{2,1,empty},{2,2,empty},{2,3,empty},
		{3,1,cpu},{3,2,empty},{3,3,empty}
	].

min_max_4_test() -> ?assertEqual(min_max(board3(),cpu), 10).
min_max_5_test() -> ?assertEqual(min_max(board3(),user), -10).
min_max_6_test() -> ?assertEqual(min_max(full_board(),cpu), 0).
min_max_7_test() -> ?assertEqual(min_max(full_board(),user), 0).

board4() ->
	[
		{1,1,cpu},{1,2,user},{1,3,cpu},
		{2,1,empty},{2,2,cpu},{2,3,empty},
		{3,1,user},{3,2,empty},{3,3,empty}
	].

min_max_8_test() -> ?assertEqual(min_max(board4(),user), 0).