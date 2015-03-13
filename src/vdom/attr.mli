
type key = string
type v =
  | String of string
  | Int    of int
  | Float  of float
  | Bool   of bool

module Map : Map.S with type key = key

type map = v Map.t
