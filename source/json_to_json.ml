(** Permet de convertir une jvalue en une string contenant un json *)

open Type;;
open Parser;;

(** Transforme un jarray en une string json *)
let rec json_string_of_jarray a = "["^(String.concat "," (List.map json_string_of_jvalue a))^"]"

(** Transforme un jobject en une string json *)
and json_string_of_jobject o ="{"^(String.concat "," (StringMap.fold (fun s jval l -> ("\""^s^"\""^":"^(json_string_of_jvalue jval))::l) o []))^"}"

(** Transforme un jvalue en une string json *)
and json_string_of_jvalue jval = match jval with
	| S s -> "\""^s^"\""
	| F f -> string_of_float f
	| B b -> (if b then "true" else "false")
	| N -> "NULL"
	| O jobj -> json_string_of_jobject jobj
	| A jarr -> json_string_of_jarray jarr;;
	
(** Transforme un jvalue en une string json puis l'affiche *)
let pretty_print a=print_string (json_string_of_jvalue a);;

pretty_print (Parser.main Lexer.token (Lexing.from_channel stdin));;
print_newline();;