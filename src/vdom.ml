
module type Attr = sig
  type k = string
  type t =
    | String of string
    | Int    of int
    | Float  of float
    | Bool   of bool
  module Map : Map.S with type key = k
  type map = t Map.t

  val compare : k -> k -> int
end

module Attr : Attr = struct
  type k = string
  type t =
    | String of string
    | Int    of int
    | Float  of float
    | Bool   of bool

  module Map = Map.Make (String)

  type map = t Map.t

  let compare = String.compare
end

module type Key = sig
  type t
  val fresh     : unit -> t
  val compare   : t -> t -> int
  val to_string : t -> string
end

module Key : Key = struct
  type t = int
  let n = ref 0

  let fresh () =
    let k = !n in
    n := k + 1;
    k

  let compare = compare
  let to_string n = "k" ^ string_of_int n
end

module type Ns = sig
  type t
  val of_string : string -> t
  val to_stirng : t -> string
  val of_uri    : Uri.t -> t
  val to_uri    : t -> Uri.t
  val compare   : t -> t -> int
end

module Ns : Ns = struct
  type t = Uri.t
  let of_string = Uri.of_string
  let to_stirng = Uri.to_string
  let of_uri x = x
  let to_uri x = x
  let compare = Uri.compare
end

module type Style = sig
  type k = string
  type t = Attr.t
  module Map : Map.S with type key = k
  type map = t Map.t
end

module Style : Style = struct
  type k = string
  type t = Attr.t
  module Map = Map.Make (String)
  type map = t Map.t
end

module type Tag = sig
  type t
  val of_string : string -> t
  val to_stirng : t -> string
  val compare   : t -> t -> int
end

module Tag = struct
  type t = string
  let of_string = String.uppercase
  let to_string t = t
  let compare = String.compare
end

module type Text = sig
  type t
  val of_string : string -> t
  val to_stirng : t -> string
  val compare   : t -> t -> int
end

module Text = struct
  type t = string
  let of_string x = x
  let to_string t = t
  let compare = String.compare
end

module type El = sig
  type el =
    { tag   : Tag.t
    ; attrs : Attr.map
    ; style : Style.map
    ; key   : Key.t option
    ; ns    : Ns.t option
    }

  type t = el

  val make :
    ?tag   : string ->
    ?attrs : Attr.map ->
    ?style : Style.map ->
    ?key   : Key.t ->
    ?ns    : string ->
    unit ->
    t

end

module El : El = struct
  type el =
    { tag   : Tag.t
    ; attrs : Attr.map
    ; style : Style.map
    ; key   : Key.t option
    ; ns    : Ns.t option
    }

  type t = el

  let omap f = function
    | None -> None
    | Some a -> Some (f a)

  let make
      ?tag:(tag = "div")
      ?attrs:(attrs = Attr.Map.empty)
      ?style:(style = Style.Map.empty)
      ?key
      ?ns
      () =
    { tag = Tag.of_string tag
    ; attrs; style; key
    ; ns = omap Ns.of_string ns
    }
end

module type Tree = sig
  type t =
    | Node of node
    | Text of Text.t
  and node =
    { el       : El.t
    ; children : t array
    }

  val text : string -> t
  val node :
    ?tag   : string ->
    ?attrs : Attr.map ->
    ?key   : Key.t ->
    ?ns    : string ->
    t array ->
    t
end

module Tree : Tree = struct
  type t =
    | Node of node
    | Text of Text.t
  and node =
    { el       : El.t
    ; children : t array
    }

  let text s = Text (Text.of_string s)

  let node ?tag ?attrs ?key ?ns children =
    Node { el = El.make ?tag ?attrs ?key ?ns (); children }
end

module Dom : Stomp.S
  with type t = Tree.t
   and type attr = Attr.t
   and module AttrMap = Attr.Map
   and type attrs = Attr.map =
struct

  type t = Tree.t
  type attr = Attr.t
  module AttrMap = Attr.Map
  type attrs = Attr.map


  let text = Tree.text

  let mk_node ~name ?attributes children =
    Tree.node ~tag:name ?attrs:attributes (Array.of_list children)

  let mk_leaf ~name ?attributes () =
    Tree.node ~tag:name ?attrs:attributes [||]

  let mk_attr ~name value = AttrMap.singleton name (Attr.String value)

end

module DomDSL = Stomp.DSL_Of (Dom)

let q = DomDSL.(El.html_ [El.body_ [text "hello world"]])
