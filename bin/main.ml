type person = {
  id : string option;
  nome : string option;
  apelido : string option;
  nascimento : string option;
  stack : string list option;
}
[@@deriving yojson]

let generate_uuid =
  Uuidm.to_string ~upper:true (Uuidm.v (`V3 (Uuidm.ns_dns, "www.example.org")))

let create_handler _request =
  Dream.log "create_handler initialized";
  let uuid = generate_uuid in
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
          id = Some generate_uuid;
          nome = None;
          apelido = Some search_term;
          nascimento = None;
          stack = None;
        }
      in
      let json_response = `List [ person_to_yojson person ] in
      Dream.json (Yojson.Safe.to_string json_response)
  | None -> Dream.empty `Bad_Request

let count _request = Dream.respond "5"

let () =
  Dream.run ~port:9999 ~interface:"0.0.0.0"
    ~error_handler:Dream.debug_error_handler
  @@ Dream.logger
  @@ Dream.router
       [
         Dream.post "/pessoas" create_handler;
         Dream.get "/pessoas/:id" get_by_id;
         Dream.get "/pessoas" get_by_term;
         Dream.get "/contagem-pessoas" count;
       ]
