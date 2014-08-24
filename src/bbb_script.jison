﻿/* Grammer of bitty brick basic script using jison *//* Copyright 2014 Yutaka Kachi MIT License */%lex%{    var parser = yy.parser;%}%%\s+                   /* skip whitespace */"_BLANK-LINE"         return 'BLANK-LINE'"INPUT"               return 'INPUT'"PRINT"               return 'PRINT'"TRUE"                return 'TRUE'"FALSE"               return 'FALSE'"PI"                  return 'PI'"E"                   return 'E'[a-zA-Z]+[a-zA-Z0-9_]*\b return 'IDENT'[0-9]+("."[0-9]+)?\b  return 'NUMBER'\".*\"                return 'STRING'"="                   return 'EQ'"!="                  return 'NE'"<"                   return 'LT'"<="                  return 'LE'">"                   return 'GT'">="                  return 'GE'"+"                   return 'PLUS'"-"                   return 'MINUS'"*"                   return 'MULT'"/"                   return 'DIVIDE'"^"                   return 'CARET'"("                   return 'RPAREN'")"                   return 'LPAREN'<<EOF>>               return 'EOF'.*\b                  return 'ERR'/lex%start program%right EQ%left PLUS MINUS%left MULT DIVIDE%right CARET%left UMINUS%%program    : lists EOF        {            var results = yy.parser.getResults();            yy.parser.clearResults();            typeof console !== 'undefined' ? console.log(results) : print(results);            return results;        }    ;lists    : stmt        { yy.parser.addResult($1);}    | lists stmt        { yy.parser.addResult($2);}    ;stmt    : BLANK-LINE        {$$ = "";}    | PRINT expr        {$$ = "alert(" + $2 + ");";}    | IDENT EQ INPUT expr        {$$ = $1 + " = bbb_script_lib.input(" + $4 + ");";}    | IDENT EQ expr        {$$ = $1 + "=" + $3 + ";";}    ;expr    : primary        {$$ = $1;}    | expr PLUS expr        {$$ = $1 + "+" + $3;}    | expr MINUS expr        {$$ = $1 + "-" + $3;}    | expr MULT expr        {$$ = $1 + "*" + $3;}    | expr DIVIDE expr        {$$ = $1 + "/" + $3;}    | expr CARET expr        {$$ = "Math.pow(" + $1 + "," + $3 + ")";}    ;primary    : NUMBER        {$$ = Number(yytext);}    | STRING        {$$ = String(yytext);}    | IDENT        {$$ = yytext;}    | RPAREN expr LPAREN        {$$ =  "(" + $2 + ")";}    | MINUS expr %prec UMINUS        {$$ = "-" + $2;}    | E        {$$ = "Math.E";}    | PI        {$$ = "Math.PI";}    | ERR        {$$ = "ERR:" + $1;}    ;%%parser.addResult = function(value) {    if (!this._results) {        this._results = [];    }    this._results.push(value);}parser.getResults = function() {    return this._results;}parser.clearResults = function() {    this._results = [];}