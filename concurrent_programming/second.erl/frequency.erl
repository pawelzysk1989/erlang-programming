%% Based on code from 
%%   Erlang Programming
%%   Francecso Cesarini and Simon Thompson
%%   O'Reilly, 2008
%%   http://oreilly.com/catalog/9780596518189/
%%   http://www.erlangprogramming.org/
%%   (c) Francesco Cesarini and Simon Thompson

-module(frequency).
-export([start/0,allocate/0,deallocate/1,stop/0,client_init/0,client/0]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
    register(frequency,
	     spawn(frequency, init, [])).

init() ->
  process_flag(trap_exit, true),    %%% ADDED
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The Main Loopflu

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      io:format("Server new frequencies state: ~w ~n", [NewFrequencies]),
      Pid ! {reply, Reply},
      loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
      NewFrequencies = deallocate(Frequencies, Freq),
      io:format("Server new frequencies state: ~w ~n", [NewFrequencies]),
      Pid ! {reply, ok},
      loop(NewFrequencies);
    {request, Pid, stop} ->
      Pid ! {reply, stopped};
    {'EXIT', Pid, _Reason} ->  
      io:format("Something went wrong with the client: ~w ~n", [Pid]),                
      NewFrequencies = exited(Frequencies, Pid), 
      loop(NewFrequencies)
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
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  link(Pid),                                               
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq) ->
  {value,{Freq,Pid}} = lists:keysearch(Freq,1,Allocated),  
  unlink(Pid),  
  io:format("Unlinked pid: ~w from ~w frequency ~n", [Pid, self()]),                                           
  NewAllocated=lists:keydelete(Freq, 1, Allocated),
  {[Freq|Free],  NewAllocated}.

exited({Free, Allocated}, Pid) ->               
  case lists:keysearch(Pid,2,Allocated) of
    {value,{Freq,Pid}} ->
      NewAllocated = lists:keydelete(Freq,1,Allocated),
      {[Freq|Free],NewAllocated}; 
    false ->
      {Free,Allocated} 
  end.

% Exercise 2.9 

client_init() ->
  spawn(frequency, client, []).

client() ->
  process_flag(trap_exit, true),
  client_loop([]).

client_loop(Allocated) ->
  receive
    allocate ->
      {ok, Freq} = allocate(),
      client_loop([Freq|Allocated]);
    deallocate ->
      [Freq|Rest] = Allocated,
      deallocate(Freq),
      client_loop(Rest);
    info ->
      io:format("Client ~w allocated frequencies: ~w ~n", [self(), Allocated]),
      client_loop(Allocated);
    exit ->
      exit(reason);
    {'EXIT', Pid, _Reason} ->  
      io:format("Server ~w is broken: ~w ~n", [Pid]),                
      client_loop(Allocated)
  end.