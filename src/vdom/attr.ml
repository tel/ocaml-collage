
type value =
  | Str   of string
  | Bool  of bool
  | Int   of int
  | Float of float
  | Hook  of Hook.t
  | Unset

type t = value

module Map = Map.Make (String)

type map = value Map.t

(* Helper function: add an attr to a hook map only if it is a hook. *)
let add_hook (key : string) (attr : t) (map : Hook.map) : Hook.map =
  match attr with
  | Hook h -> Hook.Map.add key h map
  | _      -> map

let hooks attrs = Map.fold add_hook attrs Hook.Map.empty
    
