
type t =
  | Elem  of El.t * Summary.t * t array
  | Text  of Text.t
  | Hole  of Hole.t

let text s = Text (Text.of_string s)

let node = failwith "noo"

let summarize x = match x with
  | Elem (x, sum, cs) -> sum
  | Text x ->
    { Summary.size        = 0
    ; Summary.live        = false
    ; Summary.thunked     = false
    ; Summary.child_hooks = false
    }
  | Hole x ->
    { Summary.size        = 0
    ; Summary.live        = Hole.live x
    ; Summary.thunked     = false
    ; Summary.child_hooks = false
    }
