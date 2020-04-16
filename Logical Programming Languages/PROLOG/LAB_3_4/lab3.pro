domains
sname = symbol
% hasBankDeposit
bank = symbol
account = symbol
amount = real
% record
phoneNum = symbol
address = address(symbol city, symbol street, integer house, integer apNum)
city = symbol
street = symbol
% owns
brand = symbol
color = symbol
price = real

predicates
record(sname, phoneNum, address)
owns(sname, brand, color, price)
hasBankDeposit(sname, bank, account, amount)

% Rules
viewCar(phoneNum, sname, brand, price)
brandOnly(phoneNum, brand)
viewData(sname, city, street, bank, phoneNum)

clauses
owns(yumaev, toyota, white, 14000).
owns(yumaev, mercedes, black, 40000).
owns(petrov, renault, black, 45000).
owns(vetrov, toyota, black, 30000).

record(yumaev, "89036609896", address(moscow, yuzhnaya, 15, 22)).
record(yumaev, "89036600505", address(moscow, yuzhnaya, 15, 22)).
record(yumaev, "89851101112", address(ryazan, soltsevo, 13, 14)).

record(petrov, "89068887745", address(moscow, yuzhnaya, 14, 24)).
record(vetrov, "89068886695", address(vologda, vetrovaya, 1, 86)).
record(zhorin, "89068887745", address(moscow, lubanka, 36, 78)).
record(kotova, "89068880045", address(ryazan, lenina, 13, 2)).

hasBankDeposit(yumaev, rocket_bank, "123456789", 12345).
hasBankDeposit(yumaev, sberbank, "326856789", 15000).

hasBankDeposit(petrov, rocket_bank, "123456000", 45678).
hasBankDeposit(kotova, sberbank, "326556000", 0.0).

% Rules
viewCar(PhoneNum, Sname, Brand, Price) :- record(Sname, PhoneNum, _), owns(Sname, Brand, _, Price).

brandOnly(PhoneNum, Brand) :- viewCar(PhoneNum, _, Brand, _).

viewData(Sname, City, Street, Bank, PhoneNum) :- record(Sname, PhoneNum, address(City, Street, _, _)), hasBankDeposit(Sname, Bank, _, _).

goal
% Task 1.a
% viewCar("89036609896", Sname, Brand, Price).

% Task 1.b
% brandOnly("89036609896", Brand).

% Task 2
viewData(yumaev, moscow, Street, Bank, PhoneNum).
