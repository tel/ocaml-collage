
type value =
  | Str   of string
  | Bool  of bool
  | Int   of int
  | Float of float
  | Hook  of Hook.t
  | Unset

module Map : Map.S with type key = string

type map = value Map.t
