module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

type person = {
  id : string option;
  nome : string option;
  apelido : string option;
  nascimento : string option;
  stack : string list option;
}
[@@deriving yojson]

let generate_uuid () = Uuidm.to_string ~upper:true (Uuidm.v `V4)

let format_stack items =
  let rec fmt items acc =
    match items with
    | [] -> Some acc
    | [ hd ] -> fmt [] (acc ^ hd)
    | hd :: t -> fmt t (acc ^ hd ^ ";")
  in
  fmt items ""

let add_person uuid nome apelido nascimento stack =
  let query =
    let open Caqti_request.Infix in
    (T.(
       tup2 string
         T.(
           tup4
             T.(option string)
             T.(option string)
             T.(option string)
             T.(option string)))
    ->. T.unit)
      "INSERT INTO persons (id, nickname, name, birthdate, stack) VALUES (?, \
       ?, ?, ?, ?)"
  in
  fun (module Db : DB) ->
    let open Lwt.Syntax in
    let* unit_or_error =
      Db.exec query (uuid, (apelido, nome, nascimento, stack))
    in
    Caqti_lwt.or_fail unit_or_error

let create _request =
  Dream.log "create_handler initialized";
  let uuid = generate_uuid () in
  let nome = Some "Pedro" in
  let apelido = Some "pedrofgd" in
  let nascimento = Some "2001-12-25" in
  let stack = format_stack [ "OCaml" ] in
  let open Lwt.Syntax in
  let* () =
    Dream.sql _request (add_person uuid nome apelido nascimento stack)
  in
  let location = String.cat "/pessoas/" uuid in
  Dream.respond ~status:`Created "created" ~headers:[ ("Location", location) ]

let get_by_id _request =
  Dream.log "get_by_id initialized";
  let id = Dream.param _request "id" in
  let p =
    {
      id = Some id;
      nome = None;
      apelido = None;
      nascimento = None;
      stack = None;
    }
  in
  let json_response = Yojson.Safe.to_string (person_to_yojson p) in
  Dream.json json_response

let get_by_term _request =
  Dream.log "get_by_term initialized";
  let term = Dream.query _request "t" in
  match term with
  | Some search_term ->
      let person =
        {
          id = Some (generate_uuid ());
          nome = None;
          apelido = Some search_term;
          nascimento = None;
          stack = None;
        }
      in
      let json_response = `List [ person_to_yojson person ] in
      Dream.json (Yojson.Safe.to_string json_response)
  | None ->
      Dream.warning (fun log -> log "Search term not informed!");
      Dream.empty `Bad_Request

let count_people =
    let query =
        let open Caqti_request.Infix in
        (T.unit ->! T.int)
        "SELECT COUNT(*) FROM persons;" in
    fun (module Db : DB) ->
        let open Lwt.Syntax in
        let* count_or_error = Db.find query () in
        Caqti_lwt.or_fail count_or_error


let count _request = 
    Dream.log "count initialized";
    let open Lwt.Syntax in
    let* result = Dream.sql _request count_people in
    Dream.respond (string_of_int result)

let () =
  Dream.run ~port:9999 ~interface:"0.0.0.0"
  @@ Dream.logger
  @@ Dream.sql_pool "postgresql://dream:password@db/dream"
  @@ Dream.router
       [
         Dream.post "/pessoas" create;
         Dream.get "/pessoas/:id" get_by_id;
         Dream.get "/pessoas" get_by_term;
         Dream.get "/contagem-pessoas" count;
       ]
