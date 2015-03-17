
type t =
  [ `String of string
  | `Int    of int
  | `Float  of float
  | `Bool   of bool
  | `Empty
  ]

let to_string = function
  | `String s -> Some s
  | `Int i    -> Some (string_of_int i)
  | `Float f  -> Some (string_of_float f)
  | `Bool b   -> Some (string_of_bool b)
  | `Empty    -> None

let to_buf x = match to_string x with
  | None -> None
  | Some a -> Some (Buf.of_string a)
