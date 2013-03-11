all: bin/json_to_json bin/json_to_xml bin/json_to_sql bin/json_to_type
	

bin/json_to_json:temp/lexer.cmo temp/parser.cmo temp/json_to_json.cmo temp/type.cmo
	ocamlc -I temp -o bin/json_to_json temp/type.cmo temp/lexer.cmo temp/parser.cmo temp/json_to_json.cmo
	
temp/json_to_json.cmo:source/json_to_json.ml temp/parser.cmi temp/lexer.cmi temp/type.cmi
	ocamlc -I temp -o temp/json_to_json.cmo -c source/json_to_json.ml
	
bin/json_to_xml:temp/lexer.cmo temp/parser.cmo temp/json_to_xml.cmo temp/type.cmo
	ocamlc -I temp -o bin/json_to_xml temp/type.cmo  temp/lexer.cmo temp/parser.cmo temp/json_to_xml.cmo
	
temp/json_to_xml.cmo:source/json_to_xml.ml temp/parser.cmi temp/lexer.cmi temp/type.cmi
	ocamlc -I temp -o temp/json_to_xml.cmo -c source/json_to_xml.ml
	
temp/infer_type.cmo temp/infer_type.cmi:source/infer_type.ml
	ocamlc -I temp -o temp/infer_type.cmo -c source/infer_type.ml
	
bin/json_to_sql:temp/lexer.cmo temp/parser.cmo temp/json_to_sql.cmo temp/type.cmo temp/infer_type.cmo
	ocamlc -I temp -o bin/json_to_sql temp/type.cmo temp/infer_type.cmo temp/lexer.cmo temp/parser.cmo temp/json_to_sql.cmo
	
temp/json_to_sql.cmo:source/json_to_sql.ml temp/parser.cmi temp/lexer.cmi temp/type.cmi temp/infer_type.cmi
	ocamlc -I temp -o temp/json_to_sql.cmo -c source/json_to_sql.ml
	
bin/json_to_type:temp/lexer.cmo temp/parser.cmo temp/json_to_type.cmo temp/type.cmo temp/infer_type.cmo
	ocamlc -I temp -o bin/json_to_type temp/type.cmo temp/infer_type.cmo temp/lexer.cmo temp/parser.cmo temp/json_to_type.cmo
	
temp/json_to_type.cmo:source/json_to_type.ml temp/parser.cmi temp/lexer.cmi temp/type.cmi temp/infer_type.cmi
	ocamlc -I temp -o temp/json_to_type.cmo -c source/json_to_type.ml
	
temp/parser.cmo:temp/parser.ml temp/parser.cmi temp/type.cmi
	ocamlc -I temp -o temp/parser.cmo -c temp/parser.ml
	
temp/lexer.cmo temp/lexer.cmi:temp/lexer.ml temp/parser.cmi temp/type.cmi 
	ocamlc -I temp -o temp/lexer.cmo -c temp/lexer.ml
	
temp/type.cmo temp/type.cmi:source/type.ml
	ocamlc -I temp -o temp/type.cmo -c source/type.ml
	
temp/parser.cmi:temp/parser.mli temp/type.cmi
	ocamlc  -I temp -o temp/parser.cmi -c temp/parser.mli

temp/lexer.ml:source/lexer.mll
	ocamllex -o temp/lexer.ml source/lexer.mll
	
temp/parser.ml temp/parser.mli:source/parser.mly temp/type.cmi
	ocamlyacc -b temp/parser source/parser.mly
	
clean:
	rm -f temp/*
	rm -f bin/*
	rm -f htmldoc/*
	
htmldoc:source/type.ml source/json_to_json.ml source/json_to_xml.ml source/infer_type.ml source/json_to_type.ml source/json_to_sql.ml temp/type.cmi temp/parser.cmi temp/infer_type.cmi temp/lexer.cmi
	ocamldoc -charset utf8 -html -d htmldoc -I temp source/type.ml source/json_to_json.ml source/json_to_xml.ml source/infer_type.ml source/json_to_type.ml source/json_to_sql.ml
	
	
test_json_to_json:bin/json_to_json
	@echo "Premier exemple, first.json :"
	@cat exemple/first.json | bin/json_to_json
	@echo ""
	@echo "Deuxième exemple, bd.json :"
	@cat exemple/bd.json | bin/json_to_json
	@echo ""
	
test_json_to_xml:bin/json_to_xml
	@echo "Premier exemple, first.json :"
	@cat exemple/first.json | bin/json_to_xml
	@echo ""
	@echo "Deuxième exemple, bd.json :"
	@cat exemple/bd.json | bin/json_to_xml
	@echo ""
	
test_json_to_sql:bin/json_to_sql
	@echo "Premier exemple, first.json :"
	@cat exemple/first.json | bin/json_to_sql
	@echo ""
	@echo "Deuxième exemple, bd.json :"
	@cat exemple/bd.json | bin/json_to_sql
	@echo ""
	
test_json_to_type:bin/json_to_type
	@echo "Premier exemple, first.json :"
	@cat exemple/first.json | bin/json_to_type
	@echo ""
	@echo "Deuxième exemple, bd.json :"
	@cat exemple/bd.json | bin/json_to_type
	@echo ""
