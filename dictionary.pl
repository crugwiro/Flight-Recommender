
:- module(dictionary, [starter_phrase/2, flight_description/5]).

starter_phrase(['What', 'is' | P], P).
starter_phrase(['What', '\'', 's' | T], T).
starter_phrase([Imperative | T], T) :-
    imperative(Imperative).
starter_phrase([Imperative, Asker | T], T) :-
    imperative(Imperative),
    asker(Asker).
starter_phrase(['I', 'want' | P], P).
starter_phrase(['I', 'want', 'to', 'watch' | P], P).

imperative('Give').
imperative('give').
imperative('Suggest').
imperative('suggest').
imperative('Recommend').
imperative('recommend').

asker('me').
asker('us').


% What is the cheapest flight from YVR to PAR
% What is the earliest flight from YVR to PAR
% Recommend a cheap flight to HKG from YVR 
% Recommend the cheapest flight from HKG to YVR on 2021-01-20
% What is a flight from YVR to HKG under/below 200 dollars
% is there any flight from YRV to HKG between 200 and 400 dollars



flight_description(P0, P5, Entity, C0, C5):-
	det(P0, P1, Entity, C0, C1),
	quality_adj(P1, P2, Entity, C1, C2),
	noun(P2, P3, Entity, C2, C3),
	origin_destination(P3, P4, Entity, C3, C4),
	modifying_phrase(P4, P5, Entity, C4, C5).

det(['a' | P], P, _, C, C).
det(['the' | P], P, _, C, C).
det(P, P, _, C, C).

quality_adj(['cheapest' | P], P, _, [price(250, 'LessThan')|C], C).
quality_adj(['cheap' | P], P, _, [price(250, 'LessThan')|C], C).
quality_adj(['earliest' | P], P, _, [date(2021-04-15, 'After')|C], C).
quality_adj(P, P, _, C, C).


noun(['flight' | P], P, _, C, C).



origin_destination(['from', Origin |P],P,_,[origin(Origin)|C],C).
origin_destination(['from', Origin, 'to', Destination |P],P,_,[origin(Origin), destination(Destination)|C],C).
origin_destination(['to', Destination, 'from', Origin |P],P,_,[destination(Destination), origin(Origin)|C],C).
origin_destination(P,P,_,C,C).



modifying_phrase([], _, _, C, C).
modifying_phrase([?], _, _, C, C).
modifying_phrase([.], _, _, C, C).
modifying_phrase([!], _, _, C, C).


modifying_phrase(['below', Num | P], P, _, [price(Num, 'LessThan')|C], C).
modifying_phrase(['under', Num | P], P, _, [price(Num, 'LessThan')|C], C).
modifying_phrase(['before', Num | P], P, _, [date(Num, 'beforeThen')|C], C).
modifying_phrase(['after', Num | P], P, _, [date(Num, 'AfterThen')|C], C).


% No modifying phrase
modifying_phrase(P, P, _, C, C).









