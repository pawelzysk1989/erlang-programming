%% Based on code from 
%%   Erlang Programming
%%   Francecso Cesarini and Simon Thompson
%%   O'Reilly, 2008
%%   http://oreilly.com/catalog/9780596518189/
%%   http://www.erlangprogramming.org/
%%   (c) Francesco Cesarini and Simon Thompson

-module(frequency2).
-export([start/0,allocate/0,deallocate/1,stop/0]).
-export([init/1]).
-export([start/1,allocate/1,deallocate/2,stop/1]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
    start(0).

%% Add delay parameter (simulate load)
start(Delay) when is_integer(Delay), Delay >= 0 ->
  register(frequency,
       spawn(?MODULE, init, [Delay])).

init(Delay) when is_integer(Delay), Delay >= 0 ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies,Delay).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop
%% extended looop with Delay [ms], for delay 0 (zero) no load
loop(Frequencies,Delay) ->
  timer:sleep(Delay),
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies,Delay);
    {request, Pid , {deallocate, Freq}} ->
      NewFrequencies = deallocate_(Frequencies, Freq),
      Pid ! {reply, ok},
      loop(NewFrequencies,Delay);
    {request, Pid, stop} ->
      Pid ! {reply, stopped}
  end.

%% Functional interface

allocate() ->
  allocate(infinity).

%% Timeout in milliseconds
allocate(Timeout) when Timeout =:= infinity; is_integer(Timeout), Timeout >= 0 ->
    clear(),
    frequency ! {request, self(), allocate},
    receive 
	    {reply, Reply} -> Reply
    after Timeout ->
      {error,timeout}
    end.

deallocate(Freq) ->
  deallocate(Freq,infinity).

deallocate(Freq,Timeout) when Timeout =:= infinity; is_integer(Timeout), Timeout >= 0 -> 
    clear(),
    frequency ! {request, self(), {deallocate, Freq}},
    receive 
	    {reply, Reply} -> Reply
    after Timeout ->
      {error,timeout}
    end.

stop() ->
  stop(infinity).

stop(Timeout) when Timeout =:= infinity; is_integer(Timeout), Timeout >= 0 -> 
    clear(),
    frequency ! {request, self(), stop},
    receive 
	    {reply, Reply} -> Reply
    after Timeout ->
      {error,timeout}
    end.


%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

%% added suffix _ to avoid conflict with deallocate client API fun
deallocate_({Free, Allocated}, Freq) ->
  NewAllocated=lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free],  NewAllocated}.

clear() ->
  receive
    Msg ->
      io:format("removed from mailbox: ~w~n",[Msg]),
      clear()
  after 0 ->
    ok
  end.
