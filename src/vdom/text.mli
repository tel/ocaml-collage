
type t

val of_string : string -> t
val to_string : string -> t

include Summary.Here with type t := t
