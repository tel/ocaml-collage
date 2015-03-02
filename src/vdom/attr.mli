
type value =
  | Str   of string
  | Bool  of bool
  | Int   of int
  | Float of float
  | Hook  of Hook.t
  | Unset

type t = value

module Map : Map.S with type key = string

type map = value Map.t

(* Filter the hooks out of an attribute map. *)
val hooks : map -> Hook.map
