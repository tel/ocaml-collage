module VirtualDom = struct

  open Js

  (** A VHook can be used to define your own apply property logic.

      When a hook is found in the VProperties object in either
      `patch()` or `createElement()`, instead of setting or unsetting
      the property we will invoke `hook()` or `unhook()` respectively
      so you can define what setting and unsetting a property means.
  *)
  module Hook = struct
    class type hook = object
      method hook   : Dom.element t -> js_string t -> unit meth
      method unhook : Dom.element t -> js_string t -> unit meth
    end

    (** See https://github.com/Matt-Esch/virtual-dom/blob/master/vnode/is-vhook.js *)
    let coerce (obj : < .. > t) : hook t option =
      failwith "tbi"

    type t = hook
  end

  (** Properties for virtual-dom are a weird game. At their most basic
      they are mere mappings from attribute names to values, but many
      attributes are special.

      - each property is tested using isVHook (matches hook interface)
        - "unhook possession" hooks are cached so that we don't have to search
          the entire property map to find them when the node is eliminated

      <https://github.com/Matt-Esch/virtual-dom/blob/master/vdom/apply-properties.js>

  *)
  module Property = struct
    type name = js_string t
    type value =
      [ `String  of js_string t
      | `Boolean of bool t
      | `Number  of number t
      ]
  end

(*

class type my_js_type = object

  (* read only property, read value with t##prop1 *)
  method prop1 : int readonly_prop

  (* write only property, write value with t##prop2 <- 3.14 *)
  method prop2 : float writeonly_prop

  (* both read and write *)
  method prop3 : int prop

  (* method or property starting with a capital letter can be prepend
     with an underscore. *)
  method _Array : ... (* to access the JavasScript property or method Array *)

  (* Define two methods with differant types, that translate to
     the same JavaScript method. *)
  method my_fun_int : int -> unit meth
  method my_fun_string : js_string t -> unit meth
  (* Both will actually call the my_fun JavaScript method. *)

  (* To call a javascript method starting with one underscore *)
  method __hiddenfun : ..
  method __hiddenfun_ : ..
  method __hiddenfun_something : ..
  (* This will call the _hiddenfun Javascript method *)

  (* To call the javascript method '_' *)
  method __ : ..
end

*)

end


module App = struct
  open Js
  type console =
    < log     : 'a . 'a -> unit meth
    ; info    : 'a . 'a -> unit meth
    ; warn    : 'a . 'a -> unit meth
    ; error   : 'a . 'a -> unit meth
    ; dir     : 'a . 'a -> unit meth
    ; time    : js_string t -> unit meth
    ; timeEnd : js_string t -> unit meth
    ; assert_ : bool -> unit meth
    >

  let console : console t = Unsafe.variable "console"

  let time (name : string) (f : 'a -> 'b) (a : 'a) : 'b =
    console##time(string name);
    f ();
    console##timeEnd(string name)

  let run () =
    let q = Dom_html.getElementById "foo" in
    console##log(q)

  let _ =
    Dom_html.window##onload <- Dom_html.handler (fun _ -> run (); _false)
end
