(** Converti une string json en ast puis infère son type puis affiche ce type *)

open Type;;
open Parser;;
open Infer_type;;

let v=(Parser.main Lexer.token (Lexing.from_channel stdin));;
let t=(infer_type v);;
print_string (string_of_json_type t);;
print_newline();;