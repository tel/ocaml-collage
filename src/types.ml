
module type Monoid = sig
  type t
  val unit : t
  val mult : t -> t -> t
end

module CapSet = struct

  module type S = sig
    type prop
    type value

    type t

    (** One style is a substyle of the other if it defines a subset of the properties *)
    val sub : t -> t -> bool

    val empty     : t
    val union     : t -> t -> t
    val intersect : t -> t -> t

    include Monoid with type t := t

    val cardinal : t -> int
    val is_empty : t -> bool
    val mem : t -> prop -> bool
    val lookup : t -> prop -> value option

    val singleton : prop -> value -> t
    val of_list : (prop * value) list -> t

    val add    : prop -> value -> (t -> t)
    val remove : prop -> (t -> t)
    val filter : (prop -> value -> bool) -> (t -> t)

    val diff : t -> t -> t

    val iter : (prop -> value -> unit) -> (t -> unit)
    val fold : ('a -> prop -> value -> 'a) -> 'a -> (t -> 'a)

    module FoldMap (M : Monoid) : sig
      val fold_map : (prop -> value -> M.t) -> (t -> M.t)
    end
  end

  module type Basis = sig
    type prop
    type value

    val compare : prop -> prop -> int
    val value0 : value
  end

  module Make ( Cb : Basis ) : S
    with type prop := Cb.prop
     and type value := Cb.value
  = struct

    module Cap = struct
      type t =
        { prop  : Cb.prop
        ; value : Cb.value
        }
      let mk prop value = {prop; value}
      let mk_bare prop = {prop; value = Cb.value0}
      let fold f {prop; value} = f prop value
      let prop {prop} = prop
      let value {value} = value
      let compare x y = Cb.compare x.prop y.prop
    end

    module S = Set.Make (Cap)

    type t = S.t

    let sub = S.subset

    let empty = S.empty
    let union = S.union
    let unit = empty
    let mult = union

    let lookup s p = try Some (Cap.value @@ S.find (Cap.mk_bare p) s) with | Not_found -> None;;
    let intersect = S.inter
    let cardinal = S.cardinal
    let is_empty = S.is_empty
    let mem s prop = S.mem (Cap.mk_bare prop) s
    let singleton p v = S.singleton (Cap.mk p v)
    let of_list ls = S.of_list (List.map (fun (p, v) -> Cap.mk p v) ls)
    let add p v = S.add (Cap.mk p v)
    let remove p = S.remove (Cap.mk_bare p)
    let filter pred = S.filter (Cap.fold pred)
    let diff = S.diff
    let iter f = S.iter (Cap.fold f)
    let fold f s a0 = S.fold (fun cap a -> Cap.fold (f a) cap) a0 s

    module FoldMap (M : Monoid) = struct
      let fold_map f s =
        List.fold_left
          (fun m cap -> M.mult m (Cap.fold f cap))
          M.unit
          (S.elements s)
    end
  end

end

