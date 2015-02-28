
type value =
  | Str   of string
  | Bool  of bool
  | Int   of int
  | Float of float
  | Hook  of Hook.t
  | Unset

module Map = Map.Make (String)

type map = value Map.t
