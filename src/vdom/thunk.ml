type tree

type t =
  { value  : tree
  ; render : tree option -> tree
  }

let summarize s =
  { Summary.size = 0
  ; Summary.live = false
  ; Summary.thunked = true
  ; Summary.child_hooks = false
  }
