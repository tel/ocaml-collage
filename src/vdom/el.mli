
type el =
  { tag       : Tag.t
  ; attrs     : Attr.map
  ; key       : Key.t option
  ; namespace : Namespace.t option
  ; hooks     : Hook.map
  ; summary   : Summary.t
  }

type t = el

include Summary.Here with type t := t
