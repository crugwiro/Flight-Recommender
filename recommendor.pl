:- module(recommendor, [promptUser/1, question/2, get_recommendation/2]).

:- use_module(dictionary).
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(http/http_open)).

bearer([request_header('Accept'='application/json'),authorization(bearer('T2YVUjHQWO58Uvnj72eAjuT1ermn'))]).
base_url("https://test.api.amadeus.com/v1/shopping/flight-destinations?").



promptUser(Recommendation) :-
    write("Query for movies: "),
    flush_output(current_output),
    readln(Ln),
    question(Ln, Constraints),
    get_recommendation(Constraints, Recommendation).
    %extra call 
    %write_results(Recommendation).

% Fetches constraints through dictionary.pl
question(P0, Constraints) :-
    starter_phrase(P0, P1),
    flight_description(P1, _, _, Constraints, _).


get_recommendation(Constraints, Data) :-
    parse_query_params(Constraints, Params),
    add_query_params('', Params, QueryParams),
    remove_char(QueryParams, '&',NewQueryParams),
    base_url(B_Url),
    bearer(Bearer),
    string_concat(B_Url,NewQueryParams,BUrl),
    make_api_call(BUrl, Bearer, Data).

    %merge_query_params(Params, QueryParams).
    %call_discover(QueryParams, Response),
    %take_1(Response.results, Recommendation).



% Maps predicate constraints onto their respective API key-value pair
parse_query_params([], []).
parse_query_params([Constraint|T], [Param|P]) :-
    parse_query_param(Constraint, Param),
    parse_query_params(T, P).

% Bi-directional conversion from predicate constraint to key-value pair
%parse_query_param(destination(Destination), ('destinationLocationCode', Destination)).
parse_query_param(price(Price, 'LessThan'), ('maxPrice', Price)).
parse_query_param(origin(Origin), ('origin', Origin)).


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

make_api_call(Url, Bearer, Data) :-
setup_call_cleanup(
http_open(Url, In, Bearer),
json_read_dict(In, Data),
close(In)
).
	