open Ocamlbuild_plugin;;

let _ =
  Options.use_ocamlfind := true;
  Ocamlbuild_plugin.dispatch Ocamlbuild_js_of_ocaml.dispatcher
;;

let _ =
  dispatch begin function
    | After_rules ->
      flag ["ocaml" ; "compile"] (A "-annot") ;
      flag ["ocaml" ; "compile"] (A "-g") ;
    | _ -> ()
  end
;;
