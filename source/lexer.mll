{open Parser}
rule token = parse
	[' ' '\r' '\t' '\n']     { token lexbuf }     (* skip blanks *)
	| ':'            { DP }
	| '{'	         { LEFTP}
	| '}'	         { RIGHTP}
	| '['	         { LEFTC}
	| ']'	         { RIGHTC}
	| ','	         {COMMA}
	| "false"         { FALSE }
	| "true"		{ TRUE }
	| "null"	     {NULL}
	| '-'?(['1'-'9']['0'-'9']*|'0')('.'['0'-'9']+)?(['e''E']['+''-']?['0'-'9']+)? as f {FLOAT(float_of_string(f))}
	| '"'([^'"' '\\']|('\\'['"' '\\' '/' 'b' 'f' 'n' 'r' 't' 'u']))*'"' as s  { STRING(String.sub s 1 ((String.length s)-2)) }
	| eof            { EOF }