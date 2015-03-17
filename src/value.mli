
type t =
  [ `String of string
  | `Int    of int
  | `Float  of float
  | `Bool   of bool
  | `Empty
  ]

val to_string : t -> string option
val to_buf    : t -> Buf.t option
