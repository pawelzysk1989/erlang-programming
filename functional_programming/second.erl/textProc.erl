-module(textProc).
-export([main/0]).

main() ->
    show_file_contents(formatLines(listOfStringsIntoListOfWords(get_file_contents("textProc.txt")), 50)).

formatLines(Xs,MaxLen) -> formatLines(Xs,MaxLen,"",[]).

formatLines([],_, CurrLine, Res) -> reverse([CurrLine|Res]);

formatLines([X|Xs],MaxLen,CurrLine,Res) when length(X) > MaxLen ->
	formatLines(Xs,MaxLen,X ++ " ",[CurrLine|Res]);
formatLines([X|Xs],MaxLen,CurrLine,Res) when length(CurrLine) + length(X) > MaxLen ->
	formatLines(Xs,MaxLen,X ++ " ",[CurrLine|Res]);
formatLines([X|Xs],MaxLen,CurrLine,Res) ->
	formatLines(Xs,MaxLen,CurrLine ++ X ++ " ",Res).


listOfStringsIntoListOfWords([]) -> [];
listOfStringsIntoListOfWords([X|Xs]) ->
	splitString(X," ") ++ listOfStringsIntoListOfWords(Xs).

% joinWordsWith(_, []) -> [];
% joinWordsWith(J, [X|Xs]) ->
% 	[X|J] ++ joinWordsWith(J,Xs).


% returns: list of strings 
% input: string, string of separators ex. " ;:\""
splitString(Xs,S) -> reverse(splitString(Xs,S,"",[],false)).

splitString([],_S,_W,R,false) -> R;
splitString([],_S,W,R,true) -> [reverse(W)|R];
splitString([L|Ls],S,W,R,false) -> 
	case member(L,S) of
 		true -> splitString(Ls,S,W,R,false);
 		false -> splitString(Ls,S,[L],R,true)
 	end;
splitString([L|Ls],S,W,R,true) -> 
	case member(L,S) of
 		true -> splitString(Ls,S,"", [reverse(W)|R],false);
 		false -> splitString(Ls,S,[L|W],R,true)
 	end.

% helper functions
%----------------------------------
member(_Y,[]) -> false;
member(X,[X|_Xs]) -> true;
member(Y,[_X|Xs]) -> member(Y,Xs).

reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

%----------------------------------

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

  
     

