domains
address = address(symbol city, symbol street, integer house, integer apNum)
sname, bank, account, phoneNum, city, street, brand, color = symbol
price, amount = real

predicates
record(sname, phoneNum, address)
owns(sname, brand, color, price)
hasBankDeposit(sname, bank, account, amount)
find(brand, color, sname, city, phoneNum, bank)

clauses
owns(yumaev, toyota, white, 14000).
owns(petrov, toyota, white, 14000).
owns(vetrov, toyota, white, 14000).
owns(vetrov, kia, yellow, 13000).
owns(zhorin, mercedes, blue, 18000).

record(yumaev, "89036609896", address(moscow,  yuzhnaya, 15, 22)).
record(yumaev, "89036600505", address(vologda, yuzhnaya, 15, 22)).
record(petrov, "89068887745", address(moscow,  prospekt_mira, 7, 24)).
record(vetrov, "89068886695", address(moscow,  vetrovaya, 36, 78)).
record(zhorin, "89068887745", address(ryazan,  lubanka, 36, 78)).
record(zhorin, "89068880045", address(ryazan,  lubanka, 36, 78)).

hasBankDeposit(yumaev, rocket_bank, "123456789", 12345).
hasBankDeposit(petrov, rocket_bank, "326856789", 15000).
hasBankDeposit(zhorin, otkritie, "123456000", 45678).
hasBankDeposit(zhorin, alpha_bank, "326556000", 80000).

% Rules
find(Brand, Color, Sname, City, PhoneNum, Bank) :- owns(Sname, Brand, Color, _),
						   record(Sname, PhoneNum, address(City, _, _, _)),
						   hasBankDeposit(Sname, Bank, _, _).
goal
% 1
find(toyota, white, Sname, City, PhoneNum, Bank).

%2
% find(mercedes, blue, Sname, City, PhoneNum, Bank).

% 3
% find(kia, yellow, Sname, City, PhoneNum, Bank).