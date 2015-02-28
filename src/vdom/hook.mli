
type t =
  { set   : Dom.element Js.t -> string -> unit
  ; unset : Dom.element Js.t -> string -> unit
  }

module Map : Map.S with type key = string
type map = t Map.t
