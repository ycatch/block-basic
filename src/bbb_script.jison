﻿/* Grammer of bitty brick basic script using jison *//* Copyright 2014 Yutaka Kachi MIT License */%lex%{    var parser = yy.parser;%}%%\s+                   /* skip whitespace */"_BLANK-LINE"         return 'BLANK-LINE'"INPUT"               return 'INPUT'"PRINT"               return 'PRINT'"IF"                  return 'IF'"ELSE"                return 'ELSE'"WHILE"               return 'WHILE'"TRUE"                return 'TRUE'"FALSE"               return 'FALSE'"PI"                  return 'PI'"E"                   return 'E'[a-zA-Z]+[a-zA-Z0-9_]*\b return 'IDENT'[0-9]+("."[0-9]+)?\b  return 'NUMBER'\".*\"                return 'STRING'"!="                  return 'NE'"="                   return 'EQ'"&lt;="               return 'LE'"&lt;"                return 'LT'"&gt;="               return 'GE'"&gt;"                return 'GT'"+"                   return 'PLUS'"-"                   return 'MINUS'"*"                   return 'MULT'"/"                   return 'DIVIDE'"^"                   return 'CARET'"("                   return 'LPAREN'")"                   return 'RPAREN'"{"                   return 'LBRACE'"}"                   return 'RBRACE'<<EOF>>               return 'EOF'.*\b                  return 'ERR'/lex%start program%right EQ%left PLUS MINUS%left MULT DIVIDE%right CARET%left UMINUS%%program    : lists EOF        {            var results = yy.parser.getResults();            yy.parser.clearResults();            typeof console !== 'undefined' ? console.log(results) : print(results);            return results;        }    ;lists    : stmt        { yy.parser.addResult($1);}    | lists stmt        { yy.parser.addResult($2);}    ;block    : LBRACE stmt-sq RBRACE        {$$ = "{\n " + $2 + "\n }";}    ;stmt-sq : /* empty */        {$$ = "";}    | stmt-sq stmt        {$$ = $1 + $2;}    ;stmt    : BLANK-LINE        {$$ = "";}    | assign        {$$ = $1 + ";";}    | PRINT expr        {$$ = "alert(" + $2 + ");";}    | IDENT EQ INPUT expr        {$$ = $1 + " = bbb_script_lib.input(" + $4 + ");";}    | IF cond block else_if        {$$ = "if " + $2 + $3 + $4;}    | WHILE cond block        {$$ = "while " + $2 + $3;}    ;cond    : LPAREN expr_relation RPAREN        {$$ = "( " + $2 + " )";}    ;else_if    : else_if2 else        {$$ = $1 + $2;}    ;else_if2    : /* empty */        {$$ = "";}    | else_if2 ELSE IF cond block        {$$ = $1 + " else if " + $4 + $5;}    ;else    : /* empty */        {$$ = "";}    | ELSE block        {$$ = " else " + $2;}    ;assign    : IDENT EQ expr        {$$ = $1 + "=" + $3;}    ;expr    : expr_calc    | primary    ;expr_calc    : expr PLUS expr        {$$ = $1 + "+" + $3;}    | expr MINUS expr        {$$ = $1 + "-" + $3;}    | expr MULT expr        {$$ = $1 + "*" + $3;}    | expr DIVIDE expr        {$$ = $1 + "/" + $3;}    | expr CARET expr        {$$ = "Math.pow(" + $1 + "," + $3 + ")";}    ;expr_relation    : expr EQ expr        {$$ = $1 + "==" + $3;}    | expr NE expr        {$$ = $1 + "!=" + $3;}    | expr LE expr        {$$ = $1 + "<=" + $3;}    | expr LT expr        {$$ = $1 + "<" + $3;}    | expr GE expr        {$$ = $1 + ">=" + $3;}    | expr GT expr        {$$ = $1 + ">" + $3;}    ;primary    : NUMBER        {$$ = Number(yytext);}    | STRING        {$$ = String(yytext);}    | IDENT        {$$ = yytext;}    | LPAREN expr RPAREN        {$$ =  "(" + $2 + ")";}    | MINUS expr %prec UMINUS        {$$ = "-" + $2;}    | E        {$$ = "Math.E";}    | PI        {$$ = "Math.PI";}    | ERR        {$$ = "ERR:" + $1;}    ;%%parser.addResult = function(value) {    if (!this._results) {        this._results = [];    }    this._results.push(value);}parser.getResults = function() {    return this._results;}parser.clearResults = function() {    this._results = [];}