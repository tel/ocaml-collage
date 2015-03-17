type t = Buffer.t -> Buffer.t

let unit x = x
let mult f g b = g (f b)

let of_string s   b = Buffer.add_string b s;   b
let of_buffer buf b = Buffer.add_buffer b buf; b
let of_char   c   b = Buffer.add_char   b c;   b

let to_buffer ?size0:(sz=16) f = f (Buffer.create sz)
let to_string ?size0 f = Buffer.contents (to_buffer ?size0 f)
let to_bytes  ?size0 f = Buffer.to_bytes (to_buffer ?size0 f)
