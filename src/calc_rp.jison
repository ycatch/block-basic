
/* description: Parses end executes mathematical expressions. */
/*              calculate by reverse polish notation. */
/* https://github.com/zaach/jison/blob/master/examples/calculator.jison */

/* lexical grammar */
%lex
%%

\s+ /* skip whitespace */
[0-9]+("."[0-9]+)?\b return 'NUMBER'
"*" return '*'
"/" return '/'
"-" return '-'
"+" return '+'
"^" return '^'
"!" return '!'
"%" return '%'
"PI" return 'PI'
"E" return 'E'
<<EOF>> return 'EOF'
. return 'INVALID'

/lex

/* javascript code*/

%{
/* addon code */

%}

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : e EOF
        {  var parse_out = yy.lists + " = " + $1;
	   typeof console !== 'undefined' ? console.log(parse_out) : print(parse_out);
          return parse_out; }
    ;

e
    : e e '+'
        {$$ = $1+$2;
	 yy.lists += " +: " + yytext + ", ";}
    | e e '-'
        {$$ = $1-$2;
	 yy.lists += " -: " + yytext + ", ";}
    | e e '*'
        {$$ = $1*$2;
	 yy.lists += " *: " + yytext + ", ";}
    | e e '/'
        {$$ = $1/$2;
	 yy.lists += " /: " + yytext + ", ";}
    | e e '^'
        {$$ = Math.pow($1, $2);
	 yy.lists += " ^: " + yytext + ", ";}
    | e '!'
        {{$$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
	 yy.lists += " !: " + yytext + ", ";}}
    | e '%'
        {$$ = $1/100;
	 yy.lists += " %: " + yytext + ", ";}
    | NUMBER
        {$$ = Number(yytext);
	 yy.lists += " Num: " + yytext + ", ";}
    | E
        {$$ = Math.E;
	 yy.lists += " E: " + yytext + ", ";}
    | PI
        {$$ = Math.PI;
	 yy.lists += " PI: " + yytext + ", ";}
    ;
