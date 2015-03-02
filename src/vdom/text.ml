
type t

let to_string s = s
let of_string s = s

let summarize s =
  { Summary.size        = 0
  ; Summary.live        = false
  ; Summary.thunked     = false
  ; Summary.child_hooks = false
  }
