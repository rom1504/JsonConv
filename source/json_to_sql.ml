(** Permet de tranformer une chaine json en ast puis de transformer cet ast en sql *)

open Type;;
open Parser;;
open Infer_type;;
  
(** Est utilisé pour définir l'association entre un json_type et un nom de table *)
module JsonTypeMap = Map.Make (struct
    type t = json_type
    let compare = Pervasives.compare
  end);;

(* le int sert à stocker le plus grand idt pour cette table (initialement 0) *)
(** Association entre les json_type et les noms de table *)
type associationTypeTable=((int StringMap.t)*((string*int) JsonTypeMap.t));;

(** AssociationTypeTable vide *)
let emptyAssociationTypeTable=((StringMap.empty),(JsonTypeMap.empty));;

(** Exception levé lorsqu'on est dans un cas d'un match qui n'est pas géré mais aussi n'est utilisé nulle part *)
exception On_ne_doit_pas_appeler_cette_fonction_dans_ce_cas;;

(** Applique f aux caractères de s *)
let smap f s = 
	let rec aux f s i =
		if i=(String.length s)-1 then s
		else (let _ =  s.[i]<- (f (s.[i])) in aux f s (i+1))
	in aux f s 0;;

(** Remplace les espaces par des underscore dans s *)
let stringUnderscoreOfSpace s=smap (fun a -> if a = ' ' then '_' else a) s;;
	
(** Type d'une table *)
type table=string*((string*string) list);;

(** Fonction transformant le type table en une string sql *)
let table_string_of_table (nomTable,listeAttributs)=
	"create table "^nomTable^"\n"^
	"(\n"^(String.concat ",\n" (List.map (fun (nomAttribut,typeAttribut) -> (stringUnderscoreOfSpace nomAttribut)^" "^typeAttribut) listeAttributs))^"\n);\n";;

(** Fonction pour nommer les tables *)
let nommer (n,idt)=if (idt>0) then n^(string_of_int idt) else n;;

(** Fonction pour donner les types sql à partir d'un json_type *)
let sql_type_of_simple_jvalue_type t=match t with
	|TString |TNull -> "TEXT" 
	|TBool -> "INT" 
	|TNumber -> "FLOAT" 
	|_ -> raise On_ne_doit_pas_appeler_cette_fonction_dans_ce_cas;;
	

(* on ne change pas le nom des attributs même si le nom de la table ne correspond pas : on laisse à l'utilisateur le soin de mettre en relation les tables comme il faut *)
(* n2 est le nom de la table suivante (pas toujours utile : pour les array) *)
(** Produit une table à partir d'un jobject_type *)
let rec table_of_jobject_type n t a n2=
	let attributs=
		StringMap.fold 
		(fun k v attributs -> 
			(match v with 
				| TNull | TString | TBool | TNumber-> ((k,sql_type_of_simple_jvalue_type v)::attributs)
				| TObject _ -> ((k,"INT")::attributs)
				| TArray ar -> ((k^"_begin","INT")::(k^"_end","INT")::attributs)
			)
		)
		t []
	in ((n,((n^"_idx","INT")::attributs)),a)

(** Produit une table à partir d'un jarray_type *)
and table_of_jarray_type n t a n2=
	match t with 
	| Ar ar -> 
		((n,(n^"_idx","INT")::(n2^"_begin","INT")::(n2^"_end","INT")::[]),a)
	| V -> ((n,[]),a)

(** Produit une table à partir d'un jvalue_type *)
and table_of_jvalue_type n t a n2=match t with
	| TArray ar -> table_of_jarray_type n ar a n2
	| TObject o -> table_of_jobject_type n o a n2
	| TString |TNull| TBool| TNumber -> ((n,((n^"_idx","INT")::("mainA",sql_type_of_simple_jvalue_type t)::[])),a)

(* and table_of_json_type=table_of_jvalue_type *)

(** Trouve une table correspondant au type demandé ou la crée et l'ajout dans l'association *)
and find_table_of_type nn t ((sm,tm) as a)=
		try (nommer (JsonTypeMap.find t tm),a)
		with Not_found ->
			let (n,sm) = 
				try 
					let idt=(StringMap.find nn sm) in 
					((nn,idt+1),StringMap.add nn (idt+1) sm) 
				with 
					Not_found -> ((nn,0),StringMap.add nn 0 sm)
			in let a=(sm,tm)
			in let (table,(sm,tm))=table_of_jvalue_type (nommer n) t a (let (x,y)=n in nommer (x,y+1))
			in let _=print_string (table_string_of_table table)
			in (nommer n,(sm,(JsonTypeMap.add t n tm)))
	;;

(** Génére une string à partir de l'associationTypeTable *)
(* à supprimer ?? *)
let string_of_associationTypeTable (sm,tm) =JsonTypeMap.fold (fun k (n,idt) acc ->(string_of_json_type k)^" : ("^n^","^(string_of_int idt)^")\n"^acc) tm "";;
	
(** Exception qui est levée si le type ne correpond pas à la valeur (ne devrait pas arriver) *)
exception Le_type_n_est_pas_plus_general_que_la_valeur;;

(** Transforme une jvalue en valeur sql dans les cas simples *)
let simple_sql_string_of_jvalue v=match v with
	|S s -> "\""^s^"\""
	|F f-> string_of_float f
	|B b-> if b then "1" else "0"
	|N -> "NULL"
	|_ -> raise On_ne_doit_pas_appeler_cette_fonction_dans_ce_cas;;
	
(** Prends quelques paramètres et renvoie une string sql d'insertion *)
let string_of_insert nomTable id listeNom listeValeur=
	"insert into "^(nomTable)^" ("^(String.concat "," (((nomTable)^"_idx")::listeNom))^")\n"^
	"values("^(String.concat "," ((string_of_int id)::listeValeur))^");\n";;

(** Prend une jvalue, un jvalue_type et quelques autres informations et affiche les strings sql d'insertion et les create table (via find_table_of_type) *)
let rec insert_sql_string_of_jvalue v t a id nt insererReferenceArray=
	match (v,t) with
	|(B _,TBool)|(F _,TNumber)|(S _,TString)->
		let (nt,a)=find_table_of_type nt t a
		in (string_of_insert nt id ("mainA"::[]) ((simple_sql_string_of_jvalue v)::[]),id+1,a)
	| (N,tt) -> 
		let (nta,a)=find_table_of_type nt t a in 
		let (c,d,a) = 
			(match tt with
				| TBool | TNumber | TString  | TNull -> (("mainA"::[]),("NULL"::[]),a)
				| TObject oo -> let (x,y)=StringMap.fold (fun k _ (lk,lv)-> ((k::lk),("NULL"::lv))) oo ([],[]) in (x,y,a)
				| TArray ar ->
					(match ar with
					| Ar arr ->	let (nt,a)=find_table_of_type nt arr a in  (((nt^"_begin")::(nt^"_end")::[]),("NULL"::"NULL"::[]),a)
					| V -> ([],[],a) (* ? *)
					)
			)
		in (string_of_insert nta id c d,id+1,a)
	|(O o,TObject i)-> insert_sql_string_of_jobject o i a id nt
	|(A ar,TArray i) ->  let (x,y,z,_) = insert_sql_string_of_jarray ar i a id nt insererReferenceArray in (x,y,z)
	| _ -> raise Le_type_n_est_pas_plus_general_que_la_valeur

(** Prend un jobject, un jobject_type et quelques autres informations et affiche les strings sql d'insertion et les create table (via find_table_of_type) *)
and insert_sql_string_of_jobject v t a id nt=
	let (ntO,a)=find_table_of_type nt (TObject t) a in 
	let (listeNom,listeValeur,insertAvant,id,a)=StringMap.fold 
	(fun s jval (listeNom,listeValeur,insertAvant,id,a) -> 
		let i=stringUnderscoreOfSpace s in
		let nouveauT=try StringMap.find s t with Not_found -> raise Le_type_n_est_pas_plus_general_que_la_valeur in
		(match (jval,nouveauT) with
			|(B _,TBool)|(F _,TNumber)|(S _,TString)|(N,_)-> (i::listeNom,(simple_sql_string_of_jvalue jval)::listeValeur,insertAvant,id,a)
			|(O o,TObject ot) ->
				let (suiteInvertAvant,nid,a)=insert_sql_string_of_jobject o ot a id s
				in (i::listeNom,(string_of_int id)::listeValeur,insertAvant^suiteInvertAvant,nid,a)
			|(A arr,TArray at) -> 
				let (suiteInvertAvant,nid,a,oldid)=insert_sql_string_of_jarray arr at a id s false
				in ((i^"_begin")::(i^"_end")::listeNom,(string_of_int id)::(string_of_int (oldid))::listeValeur,insertAvant^suiteInvertAvant,nid,a)
			|_ -> raise Le_type_n_est_pas_plus_general_que_la_valeur
		)) 
	v ([],[],"",id,a) in
	(insertAvant^(string_of_insert ntO id listeNom listeValeur),id+1,a)

(** Prend un jarray, un jarray_type et quelques autres informations et affiche les strings sql d'insertion et les create table (via find_table_of_type) *)	
and insert_sql_string_of_jarray v t a id nt insererReferenceArray=
	(* détermine le nom de la table où on met les valeurs faisant référence aux valeurs de l'array *)
	let w = 
		match t with 
			|Ar c -> c 
			|_ -> raise Le_type_n_est_pas_plus_general_que_la_valeur
	in let (nomTableRef,a)=
		if insererReferenceArray
		then find_table_of_type nt (TArray t) a
		else find_table_of_type nt w a
	in let (nomTableValeur,a)=
		find_table_of_type nt w a
	(* détermine le nom de la table où on met les valeurs de l'array *)
	(* insertion des valeurs de l'array *)
	in let (s3,id2,a,oldid) = 
		List.fold_left 
		(fun (ss,nid,assoc,oldid) e -> 
			let (sss,nid2,assoc2)=insert_sql_string_of_jvalue e w assoc nid nt true
			in (sss^ss,nid2,assoc2,nid)
		)
		("",(if insererReferenceArray then id+1 else id),a,0)
		v
	(* insertion des valeurs des valeurs faisant référence aux valeur de l'array *)
	in
		if insererReferenceArray
		then 
			(s3^(string_of_insert nomTableRef id ((nomTableValeur^"_begin")::(nomTableValeur^"_end")::[]) ((string_of_int (id+1))::(string_of_int (oldid))::[])),id2,a,oldid)
		else 
			(s3,id2,a,oldid)
;;
	
(** Prend un jvalue et un jvalue_type et affiche les strings sql d'insertion et les create table (via find_table_of_type) *)
let insert_value v t=print_string (let (s,_,_)=insert_sql_string_of_jvalue v t emptyAssociationTypeTable 1 "main" false in s);;


let v=(Parser.main Lexer.token (Lexing.from_channel stdin));;
let t=(infer_type v);;

insert_value v t;;

print_newline();;
