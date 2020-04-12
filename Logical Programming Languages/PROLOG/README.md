# Проги на Visual Prolog 5.2

Составные типы

```prolog
domains
    date = date(string Month, unsigned Day, unsigned Year).
    book = book(string name, string author).

predicates
    has_birthday(string, date).
    owns(string, book).

clauses
    has_birthday("John", date("April", 14, 1960)).
    owns("John", book("From Here to Eternity", "James Jones")).
```

---

John любит всех, кто любит вино (я решил эту задачу следующим образом):

```prolog
predicates
    likes(string, string).

clauses
    likes("Jane", "Wine").
    likes("Mike", "Apple").
    likes("Ellen", "Wine").
    likes("Ken", "Wine").

    likes("John", X) :- likes(X, "Wine").

goal
    likes("John", X).
```

Вывод пролога:

```shell
X=Jane
X=Ellen
X=Ken
3 Solutions
```

---

