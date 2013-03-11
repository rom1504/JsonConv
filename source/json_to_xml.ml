(** Permet de convertir une jvalue en une string contenant un xml *)
open Type;;
open Parser;;

(** Applique f aux caractères de s *)
let smap f s = 
	let rec aux f s i =
		if i=(String.length s)-1 then s
		else (let _ =  s.[i]<- (f (s.[i])) in aux f s (i+1))
	in aux f s 0;;
	
(** Remplace les espaces par des underscore dans s *)
let stringUnderscoreOfSpace s=smap (fun a -> if a = ' ' then '_' else a) s;;

(** Transforme un jarray en une string xml *)
let rec xml_string_of_jarray a = "<tab>"^(String.concat "" (List.map (fun jval -> "<item>"^(xml_string_of_jvalue jval)^"</item>") a))^"</tab>"

(** Transforme un jobject en une string xml *)
and xml_string_of_jobject o = String.concat "" (StringMap.fold (fun s jval l ->let t = stringUnderscoreOfSpace s  in  ("<"^t^">"^(xml_string_of_jvalue jval)^"</"^t^">")::l ) o [])

(** Transforme un jvalue en une string xml *)
and xml_string_of_jvalue jval = match jval with
	| S s -> s
	| F f -> string_of_float f
	| B b -> (if b then "<true/>" else "<false/>")
	| N -> "<null/>"
	| O jobj -> xml_string_of_jobject jobj
	| A jarr -> xml_string_of_jarray jarr;;
	
(** Transforme un jvalue en une string xml puis l'affiche *)
let pretty_print a=print_string (xml_string_of_jvalue a);;

pretty_print (Parser.main Lexer.token (Lexing.from_channel stdin));;
print_newline();;