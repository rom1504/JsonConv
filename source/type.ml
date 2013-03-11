(** Types pour définir un arbre de syntaxe abstrait *)

(** Est utilisé pour les jobject*)
module StringMap = Map.Make (String);;

type jobject=jvalue StringMap.t
and jvalue=S of string|F of float|B of bool|N|O of jobject|A of jarray
and jarray=jvalue list;;