-module(billing).
-export([main/0]).

main() ->
    Store=[
	    {4719, "Fish Fingers" , 121},
	    {5643, "Nappies" , 1010},
	    {3814, "Orange Jelly", 56},
	    {1111, "Hula Hoops", 21},
	    {1112, "Hula Hoops (Giant)", 133},
	    {1234, "Dry Sherry, 1lt", 540}
    ],
    Barcodes = [1234,4719,3814,1112,1113,1234,5643,5643],
    Bill = createBill(Barcodes,Store),
    Discounts = [{1234,2,100},{5643,1,20}],
    Discount = discount(Bill,Discounts),
    Total = totalPrice(fun({_,_,P1}, P2) -> P1 + P2  end, -Discount, Bill),
    showBillContent(Bill,Total,30).

totalPrice(_,Start,[]) -> Start;
totalPrice(F,Start,[B|Bs]) ->
	F(B, totalPrice(F,Start,Bs)).

discount(_,[]) -> 0;
discount(Bill,[{Barcode,Count,Discount}|Discounts]) ->
	(count(Barcode,Bill) div Count)*Discount + discount(Bill,Discounts).
   
count(_,[]) -> 0;
count(Barcode, [{Barcode,_,_}|Products]) ->
	1+count(Barcode,Products);
count(Barcode, [{_,_,_}|Products]) ->
	count(Barcode,Products).

createBill(Bs,S) -> createBill(Bs,S,[]).

createBill([],_,L) -> reverse(L);
createBill([B|Bs],S,L) ->
	case searchForBarcode(B,S) of
		{ok,B,N,P} -> createBill(Bs,S,[{B,N,P}|L]);
		no -> createBill(Bs,S,L)
	end.

searchForBarcode(_,[]) -> no;
searchForBarcode(B,[{B,N,P}|_]) -> {ok,B,N,P};
searchForBarcode(B,[{_X,_,_}|Xs]) ->
	searchForBarcode(B,Xs).

reverse(Xs) -> reverse(Xs, []).
reverse([],R) -> R;
reverse([X|Xs],R) -> reverse(Xs, [X|R]).

dots(0) -> [];
dots(N) -> [46|dots(N-1)].

showLine(Name,Dots,Price) ->
	P=float_to_list(Price/100,[{decimals,2}]),
	Name++dots(Dots-length(Name)-length(P))++P.

showBillContent([{_,N,P}|Ls],T,Dots) ->
    io:format("~s~n",[showLine(N,Dots,P)]),
    showBillContent(Ls,T,Dots);
showBillContent([],T,Dots) ->
    io:format("~s~n",[""]),  
    io:format("~s~n",[showLine("Total",Dots,T)]).