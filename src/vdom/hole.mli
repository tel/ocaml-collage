
type t

type 's spec =
  { this    : 's
  ; init    : 's -> Dom.element Js.t
  ; update  : 's -> Dom.element Js.t -> unit
  ; destroy : ('s -> Dom.element Js.t -> unit) option
  }

val make : 's spec -> t

include Summary.Here with type t := t
