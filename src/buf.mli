
type t

val unit : t
val mult : t -> t -> t

val of_string : string -> t
val of_buffer : Buffer.t -> t
val of_char   : char -> t

val to_buffer : ?size0:int -> t -> Buffer.t
val to_string : ?size0:int -> t -> string
val to_bytes  : ?size0:int -> t -> bytes
