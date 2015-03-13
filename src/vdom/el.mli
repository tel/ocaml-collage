
type el =
  { tag   : Tag.t
  ; attrs : Attr.map
  ; key   : Key.t option
  ; ns    : Ns.t option
  }

type t = el
