
-module(frequency).
-export([start/0,allocate/0,deallocate/1,stop/0]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
  register(frequency,
    spawn(frequency, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loop

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
      {NewFrequencies, Reply} = deallocate(Frequencies, Freq),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {request, Pid, stop} ->
      Pid ! {reply, stopped}
  end.

%% Functional interface

allocate() -> 
  frequency ! {request, self(), allocate},
  receive 
    {reply, Reply} -> Reply
  end.

deallocate(Freq) -> 
  frequency ! {request, self(), {deallocate, Freq}},
  receive 
    {reply, Reply} -> Reply
  end.

stop() -> 
  frequency ! {request, self(), stop},
  receive 
    {reply, Reply} -> Reply
  end.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies (modified versions)

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  case lists:keyfind(Pid, 2, Allocated) of
    false ->
      {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}};
    {AllocatedFreq, Pid} ->
      {{[Freq|Free], Allocated}, {already_allocated, {AllocatedFreq, Pid}}}
  end.

deallocate({Free, Allocated}, Freq) ->
  case lists:keyfind(Freq, 1, Allocated) of
    false ->
      {{Free, Allocated}, {frequency_not_allocated, Freq}};
    _ ->
      NewAllocated=lists:keydelete(Freq, 1, Allocated),
      {{[Freq|Free],  NewAllocated}, {ok, Freq}}
  end.



