type 's spec =
  { this    : 's
  ; init    : 's -> Dom.element Js.t
  ; update  : 's -> Dom.element Js.t -> unit
  ; destroy : ('s -> Dom.element Js.t -> unit) option
  }

type t = Hole : 's spec -> t

let make spec = Hole spec

let init   (Hole { this; init   })    = init this
let update (Hole { this; update }) el = update this el

(** Must this widget be destroyed? *)
let live (Hole { destroy }) = match destroy with
  | None -> false
  | _    -> true

(** No-op if there's no destroy method *)
let destroy (Hole { this; destroy }) el = match destroy with
  | None    -> ()
  | Some go -> go this el
