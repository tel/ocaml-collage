type 's spec =
  { this    : 's
  ; init    : 's -> Dom.element Js.t
  ; update  : 's -> Dom.element Js.t -> unit
  ; destroy : ('s -> Dom.element Js.t -> unit) option
  }

type t = Widget : 's spec -> t

let make spec = Widget spec

let init   (Widget { this; init   })    = init this
let update (Widget { this; update }) el = update this el

(** Must this widget be destroyed? *)
let live (Widget { destroy }) = match destroy with
  | None -> false
  | _    -> true

(** No-op if there's no destroy method *)
let destroy (Widget { this; destroy }) el = match destroy with
  | None    -> ()
  | Some go -> go this el

let summarize s =
  { Summary.size = 0
  ; Summary.thunked = false
  ; Summary.child_hooks = false
  ; Summary.live = live s
  }
