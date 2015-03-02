
module S = struct

  type el
  type text

  type t =
    [ `El    of el
    | `Text  of text
    | `Hole  of Hole.t
    | `Thunk of thunk
    ]

  and thunk =
    { value  : t
    ; render : t option -> t
    }


  val node :
    ?tag       : string ->
    ?attrs     : Attr.map ->
    ?key       : Key.t ->
    ?namespace : string ->
    Tree.t array ->
    t

  val text : string -> t

  include Summary.Here with type t := t

  module Thunk : sig
    include Summary.Here with type t := thunk
  end

end

module Make
    (El    : El)
    (Text  : Text)
  : S with type el    = El.t
       and type text  = Text.t
= struct

  type t =
    [ `El     of El.t
    | `Text   of Text.t
    | `Widget of Widget.t
    | `Thunk  of Thunk.t
    ]
  and thunk =
    { value  : t
    ; render : t option -> t
    }

  let summarize = function
    | `Node   x -> Node.summarize x
    | `Text   x -> Text.summarize x
    | `Widget x -> Widget.summarize x
    | `Thunk  x -> Thunk.summarize x

  module Thunk = struct
  end

end

module rec Tree : sig
  type t =
    [ `Node   of Node.t
    | `Text   of Text.t
    | `Widget of Widget.t
    | `Thunk  of Thunk.t
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
    ?tag       : string ->
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
    ; namespace : Namespace.t option
    ; hooks     : Hook.map
    ; summary   : Summary.t
    }

  let summarize x = x.summary

  let omap f = function
    | Some x -> Some (f x)
    | None   -> None


  let make
      ?tag:(tag = "div")
      ?attrs:(attrs = Attr.Map.empty)
      ?key:(key = Key.fresh ())
      ?namespace
      children
    =
    let tag       = Tag.of_string tag in
    let attrs     = attrs in
    let key       = Some key in
    let namespace = omap Namespace.of_string namespace in
    let hooks     = Attr.hooks attrs in
    let summary   = failwith "noo" in
    let children  = failwith "noo" in
    { tag; attrs; key; namespace; hooks; summary; children }
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
