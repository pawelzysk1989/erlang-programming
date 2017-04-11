-module(hernando).
-export([main/1, test/0, get_file_contents/1, show_file_contents/1]).

% Test function, Use: index:test().
test() ->
main("dickens-christmas.txt").

% Main function, Use: index:main("gettysburg-address.txt").
main(Name) ->
Lines = get_file_contents(Name),
RawIndex = index(Lines),
FormatLines = format_lines(RawIndex),
SortedLines = lists:sort(fun({A, _}, {B, _}) -> A =< B end, FormatLines),
print(SortedLines).

% Index the words
index(Lines) ->
index(Lines, [], 1).

index([], Acc, _) ->
Acc;
index([H | T], Acc, N) ->
NewIndex = append(get_words(H), Acc, N),
index(T, NewIndex, N + 1).

% Get the words in a line
get_words(Line) ->
nub(get_words(to_lower(Line), [], "")).

get_words([], Acc, Tmp) ->
case length(Tmp) > 3 of
true ->
[lists:reverse(Tmp) | Acc];
false ->
Acc
end;
get_words([H | T], Acc, Tmp) ->
case $a =< H andalso H =< $z of
true ->
get_words(T, Acc, [H | Tmp]);
false ->
case length(Tmp) > 3 of
true ->
get_words(T, [lists:reverse(Tmp) | Acc], "");
false ->
get_words(T, Acc, "")
end
end.

% Transform a line to lowercase
to_lower([]) ->
[];
to_lower([H | T]) ->
[lower(H) | to_lower(T)].

lower(C) ->
case $A =< C andalso C =< $Z of
true ->
C + 32;
false ->
C
end.

% Appned words and line numbers to index
append([], Acc, _) ->
Acc;
append([H | T], Acc, N) ->
append(T, update(H, Acc, N), N).

update(Word, [], N) ->
[{Word, [N]}];
update(H, [{H, L} | T], N) ->
[{H, [N | L]} | T];
update(Word, [H | T], N) ->
[H | update(Word, T, N)].

format_lines(List) ->
format_lines(List, []).

format_lines([], Acc) ->
Acc;
format_lines([{Word, Pages} | T], Acc) ->
format_lines(T, [{Word, format_pages(lists:reverse(Pages))} | Acc]).

% Print the index
print([]) ->
ok;
print([{Word, Pages} | T]) ->
io:format("{ ~s, ", [Word]),
io:format("~w }", [Pages]),
io:format("~n"),
print(T).

% Format page numbers
format_pages([]) ->
[];
format_pages([H | T]) ->
First = H,
{Last, NewT} = seek_last(T, First),
[{First, Last} | format_pages(NewT)].

seek_last([], N) ->
{N, []};
seek_last([H | T], N) when H == N + 1 ->
seek_last(T, H);
seek_last(L, N) ->
{N, L}.

nub([]) ->
[];
nub([H | T]) ->
[H | nub(remove(T, H))].

remove([], _) ->
[];
remove([H |T], H) ->
remove(T, H);
remove([H |T], X) ->
[H | remove(T, X)].

% Used to read a file into a list of lines.
% Example files available in:
% gettysburg-address.txt (short)
% dickens-christmas.txt (long)

% Get the contents of a text file into a list of lines.
% Each line has its trailing newline removed.

get_file_contents(Name) ->
{ok,File} = file:open(Name,[read]),
Rev = get_all_lines(File,[]),
lists:reverse(Rev).

% Auxiliary function for get_file_contents.
% Not exported.

get_all_lines(File,Partial) ->
case io:get_line(File,"") of
eof -> file:close(File),
Partial;
Line -> {Strip,_} = lists:split(length(Line)-1,Line),
get_all_lines(File,[Strip|Partial])
end.

% Show the contents of a list of strings.
% Can be used to check the results of calling get_file_contents.

show_file_contents([L|Ls]) ->
io:format("~s~n",[L]),
show_file_contents(Ls);
show_file_contents([]) ->
ok. 