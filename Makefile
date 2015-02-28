OB = ocamlbuild -use-ocamlfind -plugin-tag "package(js_of_ocaml.ocamlbuild)"

all:
	$(OB) collage.cmo

clean:
	$(OB) -clean

.PHONE: all clean
