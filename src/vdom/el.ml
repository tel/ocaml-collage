
type el =
  { tag   : Tag.t
  ; attrs : Attr.map
  ; key   : Key.t option
  ; ns    : Ns.t option
  }

type t = el

let ofold none some = function
  | None -> none
  | Some a -> some a


let make = failwith "noo"
