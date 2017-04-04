%{
#include <stdio.h>
#include <math.h>
#include "lista.h"
extern int yylex();
int yyerror(const char * msg);
extern int yylineno;
lista lVar;
int tipo;
char bufErr[128];
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

declarations:	declarations VAR {tipo=1;} identifier_list PTOCOMA { printf("declarations->declarations VAR identifier_list ;\n");}
			|	declarations LET {tipo=0;} identifier_list PTOCOMA { printf("declarations->declarations LET identifier_list ;\n");}
			|	/*Lambda*/ { printf("declarations->lambda\n");}
			| 	error PTOCOMA { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line);}
			;

identifier_list: asig { printf("identifier_list->asig\n");}
			|	identifier_list COMA asig {printf("identifier_list->identifier_list , asig\n");}
			;

asig:			ID { 	printf("asig->ID\n"); 
						if(consultarTipoVar(lVar,$1)!=-1){
							snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
							yyerror(bufErr);			
						}			
						else insertarVar(&lVar,$1,tipo);
					}
			| 	ID IGUAL expression { 	printf("asig->ID = expression\n");
										if(consultarTipoVar(lVar,$1)!=-1){
											snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
											yyerror(bufErr);			
										}						
										else insertarVar(&lVar,$1,tipo);
									}
			;

statement_list:	statement_list statement { printf("statement_list->statement_list statement\n");}
			|	/*lambda*/{ printf("statement_list->lambda\n");}
			;

statement:		ID IGUAL expression PTOCOMA { printf("statement->ID = expression ;\n"); 
												if(consultarTipoVar(lVar,$1)==-1){
													snprintf(bufErr,128,"La variable %s no ha sido declarada",$1);
													yyerror(bufErr);			
												}	
												else if(consultarTipoVar(lVar,$1)==0){
													snprintf(bufErr,128,"La variable %s se declaró como constantes",$1);
													yyerror(bufErr);			
												}		
											}
			|	ALLAVE statement_list CLLAVE { printf("statement->{ statement_list }\n");}
			| 	IF APAR expression CPAR statement ELSE statement { printf("statement->IF ( expression ) statement ELSE statement\n");}
			| 	IF APAR expression CPAR statement { printf("statement->IF ( expression ) statement\n");}
			|	WHILE APAR expression CPAR statement { printf("statement->WHILE ( expression ) statement\n");}
			|	PRINT print_list PTOCOMA { printf("statement->PRINT print_list ;\n");}
			|	READ read_list PTOCOMA { printf("statement->READ read_list ;\n");}
			| 	error CLLAVE { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line);}
			| 	error PTOCOMA { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line);}
			;
			
print_list:		print_item { printf("print_list->print_item\n");}
			|	print_list COMA print_item { printf("print_list->print_list,print_item\n");}
			;

print_item:		expression { printf("print_item->expression\n");}
			|	CADENA { printf("print_item->CADENA\n");}
			;

read_list:		ID { 	printf("read_list->ID\n");
						if(consultarTipoVar(lVar,$1)==-1){
							snprintf(bufErr,128,"La variable %s no ha sido declarada",$1);
							yyerror(bufErr);			
						}	
						else if(consultarTipoVar(lVar,$1)==0){
							snprintf(bufErr,128,"La variable %s se declaró como constantes",$1);
							yyerror(bufErr);			
						}				
					}
			|	read_list COMA ID 	{	printf("read_list->read_list , ID\n");
										if(consultarTipoVar(lVar,$3)==-1){
											snprintf(bufErr,128,"La variable %s no ha sido declarada",$3);
											yyerror(bufErr);			
										}	
										else if(consultarTipoVar(lVar,$3)==0){
											snprintf(bufErr,128,"La variable %s se declaró como constantes",$3);
											yyerror(bufErr);			
										}					
									}
			;

expression:		expression MAS expression { printf("expression->expression + expression\n");}
			|	expression MENOS expression { printf("expression->expression - expression\n");}
			|	expression POR expression { printf("expression->expression * expression\n");}
			|	expression ENTRE expression { printf("expression->expression / expression\n");}
			|	MENOS expression %prec UMENOS{ printf("expression->-expression\n");}
			|	APAR expression CPAR { printf("expression->( expression )\n");}
			|	ID	{ printf("expression->ID\n");
						if(consultarTipoVar(lVar,$1)==-1){
							snprintf(bufErr,128,"La variable %s no ha sido declarada",$1);
							yyerror(bufErr);	
						}
					}
			|	ENT { printf("expression->ENT\n");}
			;
%%
/* Rutinas C */
int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
}



















