docker run \
    -it \
    --rm \
    --name rinha-ocaml5-postgres \
    -e POSTGRES_USER=dream \
    -e POSTGRES_PASSWORD=password \
    -e POSTGRES_DB=dream \
    -p 5432:5432 \
    -v ./init.sql:/docker-entrypoint-initdb.d/init.sql:ro \
    postgres

