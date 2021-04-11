:- module(recommendor, [promptUser/1, question/2, get_recommendation/2]).

:- use_module(dictionary).
:- use_module(api).

bearer([request_header('Accept'='application/json'),authorization(bearer('OS2o0mxSz3oUQqET6fIzf8zG23oF'))]).
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


get_recommendation(Constraints, Params) :-
    parse_query_params(Constraints, Params).
    %make_api_call(Params, Data).


% Maps predicate constraints onto their respective API key-value pair
parse_query_params([], []).
parse_query_params([Constraint|T], [Param|P]) :-
    parse_query_param(Constraint, Param),
    parse_query_params(T, P).

% Bi-directional conversion from predicate constraint to key-value pair
parse_query_param(destination(Destination), ('destinationLocationCode', Destination)).
parse_query_param(price(Price, 'LessThan'), ('maxPrice', Price)).
parse_query_param(origin(Origin), ('origin', Origin)).

	
