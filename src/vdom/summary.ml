
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

let size s = s.size
let live s = s.live
let thunked s = s.thunked
let child_hooks s = s.child_hooks

let prod s1 s2 =
  let size    = s1.size    + s2.size in
  let live    = s1.live    || s2.live in
  let thunked = s1.thunked || s2.thunked in
  let child_hooks = s1.child_hooks || s2.child_hooks in
  { size; live; thunked; child_hooks }
