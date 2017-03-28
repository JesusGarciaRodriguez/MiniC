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

%token FUNC VAR LET IF ELSE WHILE PRINT READ APAR CPAR PTOCOMA COMA MAS MENOS POR ENTRE IGUAL ALLAVE CLLAVE CADENA
%token<num> ENT
%token<str> ID
%type<num> expression

// Precedencia y asociatividad
%left MAS MENOS //MAS mENOS igual precendencia, asoc por la izquierda
%left POR ENTRE	//MULT DIV MÄS PRECEDENCIA QUE TODO LO DE ARRIBA Y MISMA ENTRE ELLOS Y ASOC IZQ
%nonassoc UMENOS

%%

program: 		FUNC ID APAR CPAR ALLAVE declarations statement_list CLLAVE { printf("program->FUNC ID(){declarations statement_list}\n");}
			;

declarations:	declarations VAR identifier_list PTOCOMA { printf("declarations->declarations VAR identifier_list ;\n");}
			|	declarations LET identifier_list PTOCOMA  { printf("declarations->declarations LET identifier_list ;\n");}
			|	/*Lambda*/ { printf("declarations->lambda\n");}
			;

identifier_list: asig { printf("identifier_list->asig\n");}
			|	identifier_list COMA asig	{ printf("identifier_list->identifier_list , asig\n");}
			;

asig:			ID { printf("asig->ID\n");}
			| 	ID IGUAL expression { printf("asig->ID = expression\n");}
			;

statetment_list:	statetment_list statetment { printf("statement_list->statement_list statement\n");}
			|	/*lambda*/{ printf("statement_list->lambda\n");}
			;

statetment:		ID IGUAL expression PTOCOMA { printf("statement->ID = expression ;\n");}
			|	ALLAVE statement_list CLLAVE { printf("statement->{ statement_list }\n");}
			| 	IF APAR expression CPAR statement ELSE statement { printf("statement->IF ( expression ) statement ELSE statement\n");}
			| 	IF APAR expression CPAR statement { printf("statement->IF ( expression ) statement\n");}
			|	WHILE APAR expression CPAR statement { printf("statement->WHILE ( expression ) statement\n");}
			|	PRINT print_list PTOCOMA { printf("statement->PRINT print_list ;\n");}
			|	READ read_list PTOCOMA { printf("statement->READ read_list ;\n");}
			;
			
print_list:		print_item { printf("print_list->print_item\n");}
			|	print_list COMA print_item { printf("print_list->print_list,print_item\n");}
			;

print_item:		expression { printf("print_item->expression\n");}
			|	CADENA { printf("print_item->CADENA\n");}
			;

read_list:		ID { printf("read_list->ID\n");}
			|	read_list COMA ID { printf("read_list->read_list , ID\n");}
			;

expression:		expression MAS expression { printf("expression->expression + expression\n"); $$=$1+$3;}
			|	expression MENOS expression { printf("expression->expression - expression\n"); $$=$1-$3;}
			|	expression POR expression { printf("expression->expression * expression\n"); $$=$1*$3;}
			|	expression ENTRE expression { printf("expression->expression / expression\n"); $$=$1/$3;}
			|	MENOS expression { printf("expression->-expression\n"); $$=-$2;}
			|	APAR expression CPAR { printf("expression->( expression )\n"); $$=$2;}
			|	ID	{ printf("expression->ID\n"); /*$$=toDO CON LA LISTA;*/}
			|	ENT { printf("expression->ENT\n"); $$=$1;}
			;
%%
/* Rutinas C */


int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
	
}


























