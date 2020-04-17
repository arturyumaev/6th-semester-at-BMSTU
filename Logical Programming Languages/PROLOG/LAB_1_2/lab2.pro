domains
university = university(string).
name = string.

predicates
studies(name, university).
friend(name, name).

clauses
studies("Artur Yumaev", university("BMSTU")).
studies("Artur Yumaev", university("MSU")).
studies("Andrew Leonon", university("BMSTU")).
studies("Revaz Gergedava", university("REU")).
studies("John Lehnon", university("Harvard")).
studies("Elon Musk", university("MIT")).
studies("Elon Musk", university("Princeton")).
studies("Stevie Wonder", university("Michigan")).

friend("Artur Yumaev", "Elon Musk").
friend("Artur Yumaev", "Stevie Wonder").

% Артур дружит со всеми, кто учится в BMSTU
friend("Artur Yumaev", X) :- studies(X, university("BMSTU")).

goal
% Где учится Артур?
% studies("Artur Yumaev", X).

% Кто учится в BMSTU?
% studies(X, university("BMSTU")).

% С кем дружит Артур?
% friend("Artur Yumaev", Y).

% Где учатся друзья Артура?
friend("Artur Yumaev", X), studies(X, Y).
