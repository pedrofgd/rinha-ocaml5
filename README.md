`dune build` and 
`dune exec rinha_ocaml5` (bind at 9999) or `dune exec _build/default/bin/main.exe`

Implementation of https://github.com/zanfranceschi/rinha-de-backend-2023-q3/tree/main

## SQLite3 (temporary)

`sqlite3 db.sqlite < init.sql` to create the database.

use `sqlite3 db.sqlite` to access and run commandsm, like: `.table;` (list tables) and `PRAGMA table_info(persons);` (show table schema).
