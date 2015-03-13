OB = ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)"

all:
	$(OB) collage.cma

clean:
	$(OB) -clean

.PHONE: all clean
