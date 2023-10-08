FROM ocaml/opam:alpine as build

# Install system dependencies
RUN sudo apk add --update libev-dev openssl-dev

WORKDIR /home/opam

# Install dependencies
ADD ../rinha_ocaml5.opam rinha_ocaml5.opam
RUN opam install . --deps-only

# Build project
ADD . .
RUN opam exec -- dune build


FROM alpine:3.18 as run

RUN apk add --update libev

COPY --from=build /home/opam/_build/default/bin/main.exe /bin/rinha_ocaml5

# ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["/bin/rinha_ocaml5"]
