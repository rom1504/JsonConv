%{open Type;;
exception Pas_unicite;;%}
%token TRUE FALSE NULL
%token <string> STRING
%token <float> FLOAT
%token LEFTP RIGHTP
%token LEFTC RIGHTC
%token COMMA DP
%token EOF
%start main
%type <Type.jvalue> main
%%


main:jvalue EOF {$1};

jarray:LEFTC liste_jvalue RIGHTC {$2};

liste_jvalue:
	jvalue COMMA liste_jvalue {$1::$3}
	| jvalue	 { $1::[] }
	| {[]}
	;

jvalue:
	TRUE {B true}
	|FALSE {B false}
	| STRING {S $1}
	| jobject {O $1}
	| jarray {A $1}
	|NULL {N}
	|FLOAT {F $1}
;

jobject:LEFTP liste_jobject_value RIGHTP {$2};

liste_jobject_value:
	STRING DP jvalue COMMA liste_jobject_value { if StringMap.mem $1 $5 then raise Pas_unicite else StringMap.add $1 $3 $5 }
	| STRING DP jvalue	 { StringMap.add $1 $3 (StringMap.empty) }
	| {StringMap.empty}
;