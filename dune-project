(lang dune 3.10)

(name rinha_ocaml5)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name rinha_ocaml5)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune dream uuidm yojson ppx_deriving_yojson 
   caqti-driver-postgresql)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
