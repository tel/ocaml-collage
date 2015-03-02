
type tree

type t =
  { value  : tree
  ; render : tree option -> tree
  }

include Summary.Here with type t := t
