
type summary =
  { size        : int
  ; live        : bool
  ; thunked     : bool
  ; child_hooks : bool
  }

module type Here = sig
  type t
  val summarize : t -> summary
end

type t = summary

val size : t -> int
(** How many nodes are reachable from this root, including the root? *)
(** Widgets and text do not count as nodes and thunks mask nodes underneath. *)

val thunked : t -> bool
(** Are there any thunks in this subtree? *)

val live : t -> bool
(** Are there any widgets in this subtree which must be cleaned up? *)

val child_hooks : t -> bool
(** Do any of the children beneath this root note have property hooks? *)

val prod : t -> t -> t
(** Summaries can be combined. *)
