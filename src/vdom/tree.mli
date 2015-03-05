type t =
  | Elem  of El.t * t array
  | Text  of Text.t

val text : string -> t

val node :
  ?tag   : string ->
  ?attrs : Attr.map ->
  ?key   : Key.t ->
  ?ns    : string ->
  t array ->
  t
