-module(first).
-export([pal_check/1, palindrome_check/1, server/1, loop/1, loop2/0]).

pal_check(String) -> String==lists:reverse(String).

rem_punct(String) -> lists:filter(fun (Ch) ->
                                      not(lists:member(Ch,"\"\'\t\n "))
                                    end,
                                    String).

to_small(String) -> lists:map(fun(Ch) ->
                                  case ($A =< Ch andalso Ch =< $Z) of
                                      true -> Ch+32;
                                      false -> Ch
                                   end
                                 end,
                                 String).

palindrome_check(String) ->
    Normalise = to_small(rem_punct(String)),
    lists:reverse(Normalise) == Normalise.


server(Pid) when is_pid(Pid) ->
	receive
		stop ->
			io:format("stopped~n");
		{check, String} ->
			case palindrome_check(String) of 
				true ->
					Pid ! {result, String ++ " is a palindrome"};
				false ->
					Pid ! {result, String ++ " is NOT a palindrome"}
			end,
			server(Pid)	
	end.

loop(N) ->
  receive 
    stop -> io:format("~w~n",[N]);
    Msg -> 
    	io:format("message: ~w, n: ~w ~n",[Msg, N]),
    	loop(N)
  after 1000 ->
    loop(N+1)
  end.

loop2() ->
  receive 
    reset -> loop2()
  after 1000 ->
    io:format("tick~n"),
    loop()
  end.


