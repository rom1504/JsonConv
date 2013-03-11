(** Module infer_type : permet de passer d'une jvalue à un jvalue_type *)

open Type;;
open Parser;;

(* Est utilisé pour les jobject_type *)
module StringMap = Map.Make (String);;

(* propriété de Null : il peut être vu comme n'importe quel autre type (et est remplacé par ceux là quand nécessaire) *)

(** Type de jvalue *)
type jvalue_type=TNull|TString|TNumber|TBool|TArray of jarray_type|TObject of jobject_type

(** Type de jobject *)
and jobject_type=jvalue_type StringMap.t

(** Type de jarray *)
and jarray_type=Ar of jvalue_type | V;;

(* un jarray_type contient le type le plus général de ses éléments : il ne peut pas contenir plusieurs types mais il peut ne rien contenir*)

(** Le type json_type est un jvalue_type *)
type json_type=jvalue_type;;

(** Se produit par exemple dans le cas [3,"aa"] *)
exception Erreur_typage;;

(** Fusionne 2 jobject_type *)
let rec merge_jobject_type m1 m2 = 
  StringMap.merge 
    (fun k x0 y0 -> 
       match x0, y0 with 
         None, None -> None
       | None, Some v | Some v, None -> Some v
       | Some v1,Some v2 -> Some (merge_jvalue_type v1 v2))
    m1 m2

(** Fusionne 2 jvalue_type *)
and merge_jvalue_type v1 v2=
	if v1=v2 then v1
	else (
		match (v1,v2) with
		| (TNull,b) -> b
		| (a,TNull) -> a
		| (TObject o1,TObject o2) -> TObject (merge_jobject_type o1 o2)
		| (TArray a1,TArray a2) -> TArray (merge_jarray_type a1 a2)
		| (_,_) ->  raise Erreur_typage
	)
	
(** Fusionne 2 jarray_type *)
and merge_jarray_type a1 a2=match (a1,a2) with
	|(V,V) -> V
	|(Ar _,V) -> a1
	|(V,Ar _) -> a2
	|(Ar ar1,Ar ar2) -> Ar (merge_jvalue_type ar1 ar2)
;;

(** Ajoute une valeur associé à une clé dans un jobject_type *)
let add_jobject_type k v1 o =
	try  
		(let v2=StringMap.find k o in
		StringMap.add k (merge_jvalue_type v1 v2) o)
	with Not_found -> StringMap.add k v1 o;;

(** Prend un jarray et renvoie un jarray_type  *)
let rec infer_jarray_type a= match a with
	| v::(w::l) -> let iv=(infer_jvalue_type v) in
		Ar(match infer_jarray_type (w::l) with
		|V -> iv
		|Ar ar -> merge_jvalue_type iv ar)
	| v::[] -> Ar (infer_jvalue_type v)
	| [] ->  V
	
(** Prend un jobject et renvoie un jobject_type  *)
and infer_jobject_type o=StringMap.fold (fun s jval oo -> add_jobject_type s (infer_jvalue_type jval) oo) o StringMap.empty
	
(** Prend une jvalue et renvoie un jvalue_type  *)
and infer_jvalue_type v=match v with
	| N -> TNull
	| B _ -> TBool
	| S _ -> TString
	| F _ -> TNumber
	| O o -> TObject (infer_jobject_type o)
	| A a -> TArray (infer_jarray_type a);;
	
(** La fonction infer_type est la fonction infer_jvalue_type *)
let infer_type=infer_jvalue_type;;

(** Utilise la fonction fold de StringMap pour recréer une fonction au même comportement que String.concat mais pour les jobject *)
let stringMapConcat f i sm=
	let sa=StringMap.fold (fun k v acc ->(f k v)^i^acc) sm "" 
	in let n=(String.length sa) 
	in if n=0 then "" else String.sub sa 0 (n-1);;
	
(** Converti un jvalue_type en une string le représentant *)
let rec string_of_jvalue_type v=match v with
	| TNull -> "Null"
	| TBool -> "Bool"
	| TString -> "String"
	| TNumber -> "Number"
	| TArray a-> string_of_jarray_type a
	| TObject o-> string_of_jobject_type o
	
(** Converti un jobject_type en une string le représentant *)
and string_of_jobject_type o="Object({"^(stringMapConcat (fun k v -> "(\""^k^"\","^(string_of_jvalue_type v)^")") ";" o)^"})"

(** Converti un jarray_type en une string le représentant *)
and string_of_jarray_type a="Array("^(match a with |V -> "" |Ar ar -> string_of_jvalue_type ar)^")";;
	
(** String_of_json_type est string_of_jvalue_type *)
let string_of_json_type=string_of_jvalue_type;;