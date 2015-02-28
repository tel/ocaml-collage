
type t = int

let n = ref 0

let fresh () =
  let k = !n in
  n := k + 1;
  k

let compare x y = compare x y

let to_string n = "k" ^ string_of_int n
