﻿/* Grammer of bitty brick basic script using jison *//* Copyright 2014 Yutaka Kachi MIT License */%lex%{    var parser = yy.parser;%}%%\s+                   /* skip whitespace */"PRINT"               return 'PRINT'"PI"                  return 'PI'"E"                   return 'E'[a-zA-Z]+[a-zA-Z0-9_]*\b return 'IDENT'[0-9]+("."[0-9]+)?\b  return 'NUMBER'\".*\"                return 'STRING'"="                   return '='"+"                   return '+'"-"                   return '-'"*"                   return '*'"/"                   return '/'"^"                   return '^'"("                   return '('")"                   return ')'<<EOF>>               return 'EOF'.*\b                  return 'ERR'/lex%start program%right '='%left '+' '-'%left '*' '/'%right '^'%left UMINUS%%program    : lists EOF        {            var results = yy.parser.getResults();            yy.parser.clearResults();            typeof console !== 'undefined' ? console.log(results) : print(results);            return results;        }    ;lists    : stmt        { yy.parser.addResult($1);}    | lists stmt        { yy.parser.addResult($2);}    ;stmt    : IDENT '=' expr        {$$ = $1 + "=" + $3 + ";";}    | PRINT expr        {$$ = "alert(" + $2 + ");";}    ;expr    : primary        {$$ = $1;}    | expr '+' expr        {$$ = $1 + "+" + $3;}    | expr '-' expr        {$$ = $1 + "-" + $3;}    | expr '*' expr        {$$ = $1 + "*" + $3;}    | expr '/' expr        {$$ = $1 + "/" + $3;}    | expr '^' expr        {$$ = "Math.pow(" + $1 + "," + $3 + ")";}    ;primary    : NUMBER        {$$ = Number(yytext);}    | STRING        {$$ = String(yytext);}    | IDENT        {$$ = yytext;}    | '(' expr ')'        {$$ =  "(" + $2 + ")";}    | '-' expr %prec UMINUS        {$$ = "-" + $2;}    | E        {$$ = "Math.E";}    | PI        {$$ = "Math.PI";}    | ERR        {$$ = "ERR:" + $1;}    ;%%parser.addResult = function(value) {    if (!this._results) {        this._results = [];    }    this._results.push(value);}parser.getResults = function() {    return this._results;}parser.clearResults = function() {    this._results = [];}