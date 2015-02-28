

type t =
  {   set : Dom.element Js.t -> string -> unit
  ; unset : Dom.element Js.t -> string -> unit
  }

module Map = Map.Make (String)
type map = t Map.t
