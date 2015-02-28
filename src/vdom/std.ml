
module rec Tree : sig
  type t =
    [ `Node of Node.t
    | `Text of Text.t
    | `Widget of Widget.t
    | `Thunk of Thunk.t
    ]
  include Summary.Here with type t := t
end =
struct
  type t =
    [ `Node of Node.t
    | `Text of Text.t
    | `Widget of Widget.t
    | `Thunk of Thunk.t
    ]

  let summarize = function
    | `Node   x -> Node.summarize x
    | `Text   x -> Text.summarize x
    | `Widget x -> Widget.summarize x
    | `Thunk  x -> Thunk.summarize x
end

and Node : sig
  type t
  val make :
    ?tag_name  : string ->
    ?attrs     : Attr.map ->
    ?key       : Key.t ->
    ?namespace : string ->
    Tree.t array ->
    t
  include Summary.Here with type t := t
end =
struct
  type t =
    { tag       : Tag.t
    ; attrs     : Attr.map
    ; children  : Tree.t array
    ; key       : Key.t option
    ; namespace : string option
    ; hooks     : Hook.map
    ; summary   : Summary.t
    }

  let summarize x = x.summary

  let make
      ?tag_name:(tag_name = "div")
      ?attrs:(attrs = Attr.Map.empty)
      ?key:(key = Key.fresh ())
      ?namespace
      children
    =
    let
      get_hooks key attr map = match attr with
      | Attr.Hook h -> Hook.Map.add key h map
      | _           -> map
    in
    let hooks = Attr.Map.fold get_hooks attrs Hook.Map.empty in
    failwith "no"
end

and Text : sig
  type t
  val make : string -> t
  include Summary.Here with type t := t
end = struct
  type t = string

  let make s = s

  let summarize s =
    { Summary.size = 0
    ; Summary.live = false
    ; Summary.thunked = false
    ; Summary.child_hooks = false
    }
end

and Widget : sig
  type t
  type 's spec =
    { this    : 's
    ; init    : 's -> Dom.element Js.t
    ; update  : 's -> Dom.element Js.t -> unit
    ; destroy : ('s -> Dom.element Js.t -> unit) option
    }
  val make : 's spec -> t
  include Summary.Here with type t := t
end = struct
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
end

and Thunk : sig
  type t =
    { value  : Tree.t
    ; render : Tree.t option -> Tree.t
    }
  include Summary.Here with type t := t
end = struct
  type t =
    { value  : Tree.t
    ; render : Tree.t option -> Tree.t
    }

  let summarize s =
    { Summary.size = 0
    ; Summary.live = false
    ; Summary.thunked = true
    ; Summary.child_hooks = false
    }
end
