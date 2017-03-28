%{
#include <stdio.h>
#include <math.h>
#include "lista.h"
extern int yylex();
int yyerror(const char * msg);
extern int yylineno;
lista lVar;
%}

%union {
	int num;
	char * str; 
}

%token MAS MENOS MULT DIV PARI PARD PYC EXP EQUAL
%token<num> ENT
%token<str> ID
%type<num> fact pot term expr

%%

ini:    expr PYC { printf("ini->expr; (%d)\n",$1);}
    |   expr PYC ini { printf("ini->expr (%d); ini\n",$1);}
	|	asig PYC {printf("ini -> asig;\n");}
	|	asig PYC ini {printf("ini -> asig; ini\n");}
	;

asig:	ID EQUAL expr { printf("asig -> %s=expr\n", $1); insertarVar(&lVar, $1,$3);}
	;

expr:	expr MAS term { printf("expr->expr + term\n"); $$=$1+$3;}
    |	expr MENOS term { printf("expr->expr - term\n"); $$=$1-$3;}	
    |	term { printf("expr->term\n"); $$=$1;}	
    ;

term:	term MULT pot {printf("term->term*pot\n"); $$=$1*$3;}
	|	term DIV pot {printf("term->term/pot\n"); $$=$1/$3;}
	|	pot {printf("term->pot\n"); $$=$1;}
	;

pot:	pot EXP fact {printf("pot -> pot ^ fact\n"); $$=pow($1,$3); }
	| 	fact {printf("pot -> fact\n"); $$=$1; }
	;

fact: PARI expr PARD {printf("fact-> (expr)\n"); $$=$2;}
    | ENT {printf("fact->ENT\n"); $$=$1;}
	| MENOS fact {printf("fact->-fact\n"); $$=-$2;}
	| ID {printf("fact->%s\n", $1); $$=consultarVar(lVar,$1);}
    ;

%%
/* Rutinas C */


int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
	
}

