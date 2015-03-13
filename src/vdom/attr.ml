
type key = string
type v =
  | String of string
  | Int    of int
  | Float  of float
  | Bool   of bool

module Map = Map.Make (String)

type map = v Map.t
