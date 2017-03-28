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
%type<num> expr asig ini

// Precedencia y asociatividad
%left MAS MENOS //MAS mENOS igual precendencia, asoc por la izquierda
%left MULT DIV	//MULT DIV MÄS PRECEDENCIA QUE TODO LO DE ARRIBA Y MISMA ENTRE ELLOS Y ASOC IZQ
%left EXP
%nonassoc UMENOS

%%

ini:    ini {printf("Operacion %d\n",$1);} asig PYC {printf("ini->ini asig (%d);\n",$3); $$=$1+1;}
 	|  /*lambda*/ {$$=1 ; printf("ini-> lambda\n");}
	| error PYC { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line);}
	;

/* equivalente a 
ini:    ini contador asig PYC {printf("ini->ini asig (%d);\n",$3); $$=$1+1;}
 	|  lambda {$$=1 ; printf("ini-> lambda\n");}
	;
contador: {printf("Operacion %d\n",$<num>0);}
		;
*/

asig:	ID EQUAL expr { printf("asig -> %s=expr\n", $1); $$=$3; insertarVar(&lVar, $1,$3);}
	|	expr {printf("asig->expr\n"); $$=$1;}
	;

expr:	expr MAS expr { printf("expr->expr + expr\n"); $$=$1+$3;}
    |	expr MENOS expr { printf("expr->expr - expr\n"); $$=$1-$3;}	
    |	expr MULT expr {printf("expr->expr*expr\n"); $$=$1*$3;}
	|	expr DIV expr {printf("expr->expr/expr\n"); $$=$1/$3;}
	|	expr EXP expr {printf("expr -> expr ^ expr\n"); $$=pow($1,$3); }
	| 	PARI expr PARD {printf("expr-> (expr)\n"); $$=$2;}
    | 	ENT {printf("expr->ENT\n"); $$=$1;}
	| 	MENOS expr %prec UMENOS{printf("expr->-expr\n"); $$=-$2;}
	| 	ID {printf("expr->%s\n", $1); $$=consultarVar(lVar,$1);}
    ;

%%
/* Rutinas C */


int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
	
}
