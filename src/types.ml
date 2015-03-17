
module type Monoid = sig
  type t
  val unit : t
  val mult : t -> t -> t
end

module FixedMap = struct

  module type S = sig
    type t
    type k
    type v

    val empty     : t

    val merge     : (k -> v option -> v option -> v option) -> t -> t -> t
    val union     : t -> t -> t
    val intersect : t -> t -> t
    val diff : t -> t -> t
    val sub       : t -> t -> bool

    include Monoid with type t := t

    val cardinal : t -> int
    val is_empty : t -> bool
    val mem : k -> t -> bool
    val lookup : t -> k -> v option

    val map  : (v -> v) -> (t -> t)
    val mapi : (k -> v -> v) -> (t -> t)

    val singleton : k -> v -> t
    val of_list : (k * v) list -> t

    val add    : k -> v -> (t -> t)
    val remove : k -> (t -> t)
    val filter : (k -> v -> bool) -> (t -> t)

    val partition : (k -> v -> bool) -> (t -> t * t)

    val iter : (k -> v -> unit) -> (t -> unit)
    val fold : ('r -> k -> v -> 'r) -> 'r -> (t -> 'r)

    module FoldMap (M : Monoid) : sig
      val fold_map : (k -> v -> M.t) -> (t -> M.t)
    end
  end

  module type Basis = sig
    type k
    type v

    val compare : k -> k -> int
  end

  module Make ( Fb : Basis ) : S
    with type k := Fb.k
     and type v := Fb.v
  = struct

    module M = Map.Make (struct
        type t = Fb.k
        let compare = Fb.compare
      end)

    type t = Fb.v M.t
    open M

    let sub = failwith "noo"

    let merge = failwith "noo"
    let map = M.map
    let mapi = M.mapi
    let partition = failwith "noo"

    let empty = M.empty
    let union = failwith "noo"
    let unit = empty
    let mult = union

    let lookup s p = try Some (M.find p s) with Not_found -> None
    let intersect = failwith "noo"
    let cardinal = M.cardinal
    let is_empty = M.is_empty
    let mem = M.mem
    let singleton = M.singleton
    let of_list = List.fold_left (fun s (k, v) -> M.add k v s) M.empty
    let add = M.add
    let remove = M.remove
    let filter = M.filter
    let diff = failwith "noo"
    let iter = M.iter
    let fold f r s = M.fold (fun k v a -> f a k v) s r

    module FoldMap (Mon : Monoid) = struct
      let fold_map f s =
        List.fold_left
          (fun m (k, v) -> Mon.mult m (f k v))
          Mon.unit
          (M.bindings s)
    end
  end

end

