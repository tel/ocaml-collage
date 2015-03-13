
type t =
  | Node  of node
  | Text  of Text.t
and node =
  { el       : El.t
  ; children : t array
  }

let text s = Text (Text.of_string s)

let node = failwith "noo"
