
type el =
  { tag       : Tag.t
  ; attrs     : Attr.map
  ; key       : Key.t option
  ; namespace : Namespace.t option
  ; hooks     : Hook.map
  }

type t = el
