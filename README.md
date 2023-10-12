`dune build` and 
`dune exec rinha_ocaml5` (bind at 9999) or `dune exec _build/default/bin/main.exe`

Implementation of https://github.com/zanfranceschi/rinha-de-backend-2023-q3/tree/main

## PostgreSQL

Run `sh sample-pgdb.sh` to create a container for testing.
`docker-compose.yml` will also create a db container. Use `sh deploy.sh` to up containers.

**Note:** For running outside Docker, the connection string should be:
```
postgresql://dream:password@127.0.0.1:5432/dream
```
