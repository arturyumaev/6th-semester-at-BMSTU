/*****************************************************************************

		Copyright (c) Artur Yumaev

Project:  TEST
FileName: TEST.PRO
Purpose: Educational
Written by: Artur Yumaev
Comments:

******************************************************************************/
domains
city = string.
country = string.
street = string.
home = integer.
home_phone = string.
fname = string.
sname = string.
phone = string.
N = integer.

address = address(city, street, home).

predicates
entry(fname, sname, address, phone).

item(N).
menu.
repeat.

clauses
% Entries
entry("Ellen", "Soul", address("Moscow", "Lubanka", 35), "11111").
entry("Jimmy", "Fallon", address("Moscow", "Tverskaya", 18), "22222").
entry("Michael", "Jordan", address("SPB", "Baumanskaya", 16), "33333").
entry("Chris", "Paul", address("NY", "Green Av", 5), "44444").

% Menu interface
menu :- repeat, write("\nChoose menu number and press Enter"), nl,
		write("1 - all information"), nl,
		write("2 - search by first name"), nl,
		write("3 - search by last name"), nl,
		write("4 - search by number"), nl,
		write("5 - search by city"), nl,
		write("0-exit"), nl,
	readint(N), item(N), N=0.

% Menu items
item(N) :- N=1, entry(Fn, Sn, address(C, Str, H), Ph),
		writef("% % from %, %, %. Phone: %", Fn, Sn, C, Str, H, Ph), nl, fail.

item(N) :- N=2, write("Please, enter first name:"), nl, readln(NameToSearch),
		entry(NameToSearch, Sn, address(C, Str, H), Ph),
		writef("% % from %, %, %. Phone: %", NameToSearch, Sn, C, Str, H, Ph), nl, fail.

item(N) :- N=3, write("Please, enter last name:"), nl, readln(NameToSearch),
		entry(Fn, NameToSearch, address(C, Str, H), Ph),
		writef("% % from %, %, %. Phone: %", Fn, NameToSearch, C, Str, H, Ph), nl, fail.

item(N) :- N=4, write("Please, enter a number:"), nl, readln(Number),
		entry(Fn, Sn, address(C, Str, H), Number),
		writef("% % from %, %, %. Phone: %", Fn, Sn, C, Str, H, Number), nl, fail.

item(N) :- N=5, write("Please, enter a city:"), nl, readln(City),
		entry(Fn, Sn, address(City, Str, H), Ph),
		writef("% % from %, %, %. Phone: %", Fn, Sn, City, Str, H, Ph), nl, fail.

item(0) :- write("Exit"), nl.

repeat.
repeat :- repeat.

goal
menu.