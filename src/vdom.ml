
(** A hook allows for custom behavior on property setting and unsetting during
    both dom creation and patching. *)
module Hook = struct
  type t =
    { set   : el:Dom.element Js.t -> prop:string -> unit
    ; unset : el:Dom.element Js.t -> prop:string -> unit
    }
  module Map = Map.Make (String)
  type map = t Map.t
end

module Attr = struct
  type value =
    | Str   of string
    | Bool  of bool
    | Int   of int
    | Float of float
    | Hook  of Hook.t
    | Unset
  module Map = Map.Make (String)
  type map = value Map.t
end

module Style = struct
  module Map = Map.Make (String) 
  type t = Attr.value Map.t
end

module type Key = sig
  type t
  val compare : t -> t -> int
  val fresh : unit -> t
end

module type Tag = sig
  type t
  val of_string : string -> t
  val compare : t -> t -> int
end

module X (Key : Key) (Tag : Tag) = struct

  module type El = sig
    type t

    val size : t -> int
    (** How many elements exist in this subtree including the current one? *)

    val has_thunks : t -> bool
    (** Are there any thunks in this subtree? *)

    val has_live_widgets : t -> bool
    (** Are there any widgets in this subtree which must be cleaned up? *)

    val descendent_hooks_exist : t -> bool
    (** Do any of the children beneath this root note have property hooks? *)

  end

  module rec Tree : sig
    type t =
      [ `Node of Node.t
      | `Text of Text.t
      | `Widget of Widget.t
      | `Thunk of Thunk.t
      ]
    include El with type t := t
  end =
  struct
    type t =
      [ `Node of Node.t
      | `Text of Text.t
      | `Widget of Widget.t
      | `Thunk of Thunk.t
      ]

    let size = function
      | `Node   x -> Node.size x
      | `Text   x -> Text.size x
      | `Widget x -> Widget.size x
      | `Thunk  x -> Thunk.size x

    let has_thunks = function
      | `Node   x -> Node.has_thunks x
      | `Text   x -> Text.has_thunks x
      | `Widget x -> Widget.has_thunks x
      | `Thunk  x -> Thunk.has_thunks x

    let has_live_widgets = function
      | `Node   x -> Node.has_live_widgets x
      | `Text   x -> Text.has_live_widgets x
      | `Widget x -> Widget.has_live_widgets x
      | `Thunk  x -> Thunk.has_live_widgets x

    let descendent_hooks_exist = function
      | `Node   x -> Node.descendent_hooks_exist x
      | `Text   x -> Text.descendent_hooks_exist x
      | `Widget x -> Widget.descendent_hooks_exist x
      | `Thunk  x -> Thunk.descendent_hooks_exist x
  end

  and Node : sig
    type t
    val make :
      ?tag_name : string ->
      ?attrs : Attr.map ->
      ?key : Key.t ->
      ?namespace : string ->
      Tree.t array ->
      t
    include El with type t := t
  end =
  struct
    type summary =
      { size                   : int
      ; has_live_widgets       : bool
      ; has_thunks             : bool
      ; descendent_hooks_exist : bool
      }
    type t =
      { tag       : Tag.t
      ; attrs     : Attr.map
      ; children  : Tree.t array
      ; key       : Key.t option
      ; namespace : string option
      ; hooks     : Hook.map
      ; summary   : summary
      }

  let size x = x.summary.size
  let has_live_widgets x = x.summary.has_live_widgets
  let has_thunks x = x.summary.has_thunks
  let descendent_hooks_exist x = x.summary.descendent_hooks_exist

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
    let
      account summ child =
      let count = summ.size + Tree.size child in
      let must_clean_widgets = 3 in
      failwith "no"
    in failwith "no"

  end

  and Text : sig
    type t
    val make : string -> t
    include El with type t := t
  end = struct
    type t = string

    let make s = s

    let size _                   = 0
    let has_live_widgets _       = false
    let has_thunks _             = false
    let descendent_hooks_exist _ = false
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
    include El with type t := t
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

    let size _                   = 0
    let has_live_widgets x       = live x
    let has_thunks _             = false
    let descendent_hooks_exist _ = false
  end

  and Thunk : sig
    type t
    include El with type t := t
  end = struct
    type t =
      { value  : Tree.t
      ; render : Tree.t option -> Tree.t
      }

    let size _                   = 0
    let has_live_widgets x       = false
    let has_thunks _             = true
    let descendent_hooks_exist _ = false
  end

end
