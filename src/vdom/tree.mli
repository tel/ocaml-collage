type t =
  | Node  of node
  | Text  of Text.t
and node =
  { el       : El.t
  ; children : t array
  }

val text : string -> t

val node :
  ?tag   : string ->
  ?attrs : Attr.map ->
  ?key   : Key.t ->
  ?ns    : string ->
  t array ->
  t
