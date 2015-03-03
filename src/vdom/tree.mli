(**

   Currently I'm ignoring the Thunk concept from the original library. It's
   purely an optimization and customization trick. It might have even been
   worthwhile to eliminate Hole and Hook!
   
*)

type t =
  | Elem  of El.t * Summary.t * t array
  | Text  of Text.t
  | Hole  of Hole.t

val text : string -> t

val node :
  ?tag   : string ->
  ?attrs : Attr.map ->
  ?key   : Key.t ->
  ?ns    : string ->
  t array ->
  t

include Summary.Here with type t := t
