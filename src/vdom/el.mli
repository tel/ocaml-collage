
type t

val size : t -> int
(** How many elements exist in this subtree including the current one? *)

val has_thunks : t -> bool
(** Are there any thunks in this subtree? *)

val has_live_widgets : t -> bool
(** Are there any widgets in this subtree which must be cleaned up? *)

val descendent_hooks_exist : t -> bool
(** Do any of the children beneath this root note have property hooks? *)
