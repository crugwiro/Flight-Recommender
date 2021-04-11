:- module(api,[make_api_call/3, base_url/1]).

:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

bearer([request_header('Accept'='application/json'),authorization(bearer('OS2o0mxSz3oUQqET6fIzf8zG23oF'))]).
base_url("https://test.api.amadeus.com/v1/shopping/flight-destinations?").


make_api_call(Url, Data) :-
setup_call_cleanup(
http_open(Url, In, Bearer),
json_read_dict(In, Data),
close(In)
).

call_api(Params, Data) :-
base_url(B_Url),
add_query_params(B_Url,Params,Url),
make_api_call(Url, Data).


% Adds query parameters to given url.
add_query_params(Url, [], Url).
add_query_params(Url, [(Key, Val)|Tail], NewUrl) :- 
	make_query_param(Key, Val, Param),
	string_concat(Url, Param, NextUrl),
	add_query_params(NextUrl, Tail, NewUrl).

% Transforms key, val => "&" + Key + "=" + Val
make_query_param(Key, Val, Param) :-
	string_concat("&", Key, Front),
	string_concat("=", Val, Back),
	string_concat(Front, Back, Param).


% remove the first & because our api does not work with it.
remove_char(S,C,X) :- atom_concat(L,R,S), atom_concat(C,W,R), atom_concat(L,W,X).
	