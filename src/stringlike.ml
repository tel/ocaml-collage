
module type S = sig
  type t
  val compare : t -> t -> int
  val of_string : string -> t
  val to_string : t -> string
end

module Simple : S = struct
  include String
  let of_string s = s
  let to_string s = s
end
