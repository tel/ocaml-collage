
type t

type 's spec =
  { this    : 's
  ; init    : 's -> Dom.element Js.t
  ; update  : 's -> Dom.element Js.t -> unit
  ; destroy : ('s -> Dom.element Js.t -> unit) option
  }

val make : 's spec -> t
val live : t -> bool
val destroy : t -> Dom.element Js.t -> unit
