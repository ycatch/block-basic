
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
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    : e e '+'
        {$$ = $1+$2;}
    | e e '-'
        {$$ = $1-$2;}
    | e e '*'
        {$$ = $1*$2;}
    | e e '/'
        {$$ = $1/$2;}
    | e e '^'
        {$$ = Math.pow($1, $2);}
    | e '!'
        {{
          $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
        }}
    | e '%'
        {$$ = $1/100;}
    | '-' e %prec UMINUS
        {$$ = -$2;}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = Number(yytext);}
    | E
        {$$ = Math.E;}
    | PI
        {$$ = Math.PI;}
    ;
