%{
#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "listaVar.h"
//#include "listaStr.h"
#define TAM_ETIQ 10

extern int yylex();
int yyerror(const char * msg);
extern int yylineno;
char * nuevaEtiqueta();
listaVar lVar;
int tipo;
char bufErr[128];
int num_errores=0;
int num_etiq=0;
%}

%union {
	char * str;
	ops mips; 
}

%token FUNC VAR LET IF ELSE WHILE PRINT READ APAR CPAR PTOCOMA COMA MAS MENOS POR ENTRE IGUAL ALLAVE CLLAVE CADENA DO
%token<str> ID ENT
%type<mips> expression statement statement_list

// Precedencia y asociatividad
%left MAS MENOS //MAS mENOS igual precendencia, asoc por la izquierda
%left POR ENTRE	//MULT DIV MÄS PRECEDENCIA QUE TODO LO DE ARRIBA Y MISMA ENTRE ELLOS Y ASOC IZQ
%nonassoc UMENOS

%%

program: 		FUNC ID APAR CPAR ALLAVE declarations statement_list CLLAVE { printf("program->FUNC ID(){declarations statement_list}\n"); 	imprimirListaVar(lVar);} //if(num_Errores==0)// .data imprimirStrings  imprimirIds  //main imprimirCodigo(&$6); imprimirCodigo(&$7);  liberarMips? else printf("Errores encontrados: %d.",num_errores);
			;

declarations:	declarations VAR {tipo=1;} identifier_list PTOCOMA { printf("declarations->declarations VAR identifier_list ;\n");} 
			|	declarations LET {tipo=0;} identifier_list PTOCOMA { printf("declarations->declarations LET identifier_list ;\n");}
			|	/*Lambda*/ { printf("declarations->lambda\n");}
			// DA CONFLICTO| 	error PTOCOMA { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line); num_errores++;}
			;

identifier_list: asig { printf("identifier_list->asig\n");}
			|	identifier_list COMA asig {printf("identifier_list->identifier_list , asig\n");}
			;

asig:			ID { 	printf("asig->ID\n"); 
						if(consultarTipoVar(lVar,$1)!=-1){
							snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
							yyerror(bufErr);			
							num_errores++;
						}			
						else insertarVar(&lVar,$1,tipo);
					}
			| 	ID IGUAL expression { 	printf("asig->ID = expression\n");				//Bloque de código 
										if(consultarTipoVar(lVar,$1)!=-1){
											snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
											yyerror(bufErr);	
											num_errores++;		
										}						
										else insertarVar(&lVar,$1,tipo);
									}
			;

statement_list:	statement_list statement { printf("statement_list->statement_list statement\n");}
			|	/*lambda*/{ $$.prim=NULL; $$.ult==NULL;}	//Por culpa de esto hay que comprobar todos los ult y prim
			;

statement:		ID IGUAL expression PTOCOMA { 
												if(consultarTipoVar(lVar,$1)==-1){
													snprintf(bufErr,128,"La variable %s no ha sido declarada",$1);
													yyerror(bufErr);
													num_errores++;			
												}	
												else if(consultarTipoVar(lVar,$1)==0){
													snprintf(bufErr,128,"La variable %s se declaró como constante",$1);
													yyerror(bufErr);
													num_errores++;			
												}	
												if(num_errores==0){ 
													$$.prim=$3.prim; 
													$$.ult=crearOp("sw",$3.ult->res,concatStr("_",$1),NULL); 
													$3.ult->sig=$$.ult; 
													liberarReg($3.ult->res);
												}	
											}
			|	ALLAVE statement_list CLLAVE { $$=$2;}		
			| 	IF APAR expression CPAR statement ELSE statement 	{ 
						 												if(num_errores==0){
																			char* etiquetaIf=nuevaEtiqueta();
																			char* etiquetaElse=nuevaEtiqueta();
																			ops aux1;
																			aux1.prim=crearOp("beqz",$3.ult->res,etiquetaElse,NULL);
																			aux1.ult=aux1.prim;
																			ops aux2;
																			aux2.prim=crearOp("b",etiquetaIf,NULL,NULL);
																			aux2.ult=crearOp("etiq",$5.ult->res,etiquetaElse,NULL);
																			aux2.prim->sig=aux2.ult;
																			ops aux3;
																			aux3.prim=crearOp("etiq",etiquetaIf,NULL,NULL);
																			aux3.ult=aux3.prim;
																			ops tablaListas[6]={$3,aux1,$5,aux2,$7,aux3};
																			concatenarListasOp($$.prim,$$.ult,tablaListas,6);
																			liberarReg($3.ult->res);
																		}
																	}
			| 	IF APAR expression CPAR statement 	{
		 												if(num_errores==0){
															char* etiqueta=nuevaEtiqueta();
															ops aux1;
															aux1.prim=crearOp("beqz",$3.ult->res,etiqueta,NULL);
															aux1.ult=aux1.prim;
															ops aux2;
															aux2.prim=crearOp("etiq",etiqueta,NULL,NULL);
															aux2.ult=aux2.prim;
															ops tablaListas[4]={$3,aux1,$5,aux2};
															concatenarListasOp($$.prim,$$.ult,tablaListas,4);
															liberarReg($3.ult->res);
														}
													} 

			|	WHILE APAR expression CPAR statement 	{ 
			 												if(num_errores==0){
																char* etiquetaInicio=nuevaEtiqueta();
																char* etiquetaFin=nuevaEtiqueta();
																ops aux1;
																aux1.prim=crearOp("etiq",etiquetaInicio,NULL,NULL);
																aux1.ult=aux1.prim;
																ops aux2;
																aux2.prim=crearOp("beqz",$3.ult->res,etiquetaFin,NULL);
																aux2.ult=aux2.prim;
																ops aux3;
																aux3.prim=crearOp("b",etiquetaInicio,NULL,NULL);
																aux3.ult=crearOp("etiq",etiquetaFin,NULL,NULL);
																aux3.prim->sig=aux3.ult;
																ops tablaListas[5]={aux1,$3,aux2,$5,aux3};
																concatenarListasOp($$.prim,$$.ult,tablaListas,5);
																liberarReg($3.ult->res);
															}
														}
			|	DO statement WHILE APAR expression CPAR {
			 												if(num_errores==0){
																char* etiqueta=nuevaEtiqueta();
																ops aux1;
																aux1.prim=crearOp("etiq",etiqueta,NULL,NULL);
																aux1.ult=aux1.prim;
																ops aux2;
																aux2.prim=crearOp("bnez",$5.ult->res,etiqueta,NULL);
																aux2.ult=aux2.prim;
																ops tablaListas[4]={aux1,$2,$5,aux2};
																concatenarListasOp($$.prim,$$.ult,tablaListas,4);
																liberarReg($5.ult->res);
															}
														}
			|	PRINT print_list PTOCOMA { printf("statement->PRINT print_list ;\n");}
			|	READ read_list PTOCOMA { printf("statement->READ read_list ;\n");}
			| 	error CLLAVE { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line); num_errores++;} 
			| 	error PTOCOMA { printf("Error detectado al analizar la entrada en: %d: %d-%d: %d\n", @1.first_line,@1.first_column,@1.last_column,@1.last_line); num_errores++;}
			;
			
print_list:		print_item { printf("print_list->print_item\n");}
			|	print_list COMA print_item { printf("print_list->print_list,print_item\n");}
			;

print_item:		expression { printf("print_item->expression\n");}//mv $a0, $res
			|	CADENA { printf("print_item->CADENA\n");}//Añadirlo a la lista de string junto con su etiqueta (por ejemplo dejar etiquetas ahí la $a0, etiq
			;

read_list:		ID { 	printf("read_list->ID\n");
						if(consultarTipoVar(lVar,$1)==-1){
							snprintf(bufErr,128,"La variable %s no ha sido declarada",$1);			//Llamada al sistema 5
							yyerror(bufErr);	
							num_errores++;		
						}	
						else if(consultarTipoVar(lVar,$1)==0){
							snprintf(bufErr,128,"La variable %s se declaró como constante",$1);
							yyerror(bufErr);	
							num_errores++;		
						}				
					}
			|	read_list COMA ID 	{	printf("read_list->read_list , ID\n");
										if(consultarTipoVar(lVar,$3)==-1){
											snprintf(bufErr,128,"La variable %s no ha sido declarada",$3);
											yyerror(bufErr);			
											num_errores++;
										}	
										else if(consultarTipoVar(lVar,$3)==0){
											snprintf(bufErr,128,"La variable %s se declaró como constante",$3);
											yyerror(bufErr);	
											num_errores++;		
										}					
									}
			;

expression:		expression MAS expression 	{ 
												if(num_errores==0){
													$$.prim=$1.prim;
													$1.ult->sig=$3.prim;
													$3.ult->sig=crearOp("add",obtenerReg(),$1.ult->res,$3.ult->res);
													$$.ult=$3.ult->sig;
													liberarReg($1.ult->res);
													liberarReg($3.ult->res);
												}
											}
			|	expression MENOS expression {
												if(num_errores==0){
													$$.prim=$1.prim;
													$1.ult->sig=$3.prim;
													$3.ult->sig=crearOp("sub",obtenerReg(),$1.ult->res,$3.ult->res);
													$$.ult=$3.ult->sig;
													liberarReg($1.ult->res);
													liberarReg($3.ult->res);
												}
											}
			|	expression POR expression 	{ 
												if(num_errores==0){
													$$.prim=$1.prim;
													$1.ult->sig=$3.prim;
													$3.ult->sig=crearOp("mul",obtenerReg(),$1.ult->res,$3.ult->res);
													$$.ult=$3.ult->sig;
													liberarReg($1.ult->res);
													liberarReg($3.ult->res);
												}
											}
			|	expression ENTRE expression 	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$3.prim;
														$3.ult->sig=crearOp("sub",obtenerReg(),$1.ult->res,$3.ult->res);
														$$.ult=$3.ult->sig;
														liberarReg($1.ult->res);
														liberarReg($3.ult->res);
													}
												}
			|	MENOS expression %prec UMENOS	{ 
													if(num_errores==0){
														$$.prim=$2.prim;
														$2.ult->sig=crearOp("neg",obtenerReg(),$2.ult->res,NULL);
														$$.ult=$2.ult->sig;
														liberarReg($2.ult->res);
													}
												}
			|	APAR expression CPAR { $$=$2; }
			|	ID	{ 
						if(consultarTipoVar(lVar,$1)==-1){
							snprintf(bufErr,128,"La variable %s no ha sido declarada",$1); 
							yyerror(bufErr);	
							num_errores++;
						}
						if(num_errores==0){
							$$.prim=crearOp("lw",obtenerReg(),concatStr("_",$1),NULL); 
							$$.ult=$$.prim; 
						}
					}
			|	ENT { 
						if(num_errores==0){
							$$.prim=crearOp("li",obtenerReg(),concatStr("#",$1),NULL); 
							$$.ult=$$.prim; 
						}
					}
			;
%%
/* Rutinas C */
int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
}

char * nuevaEtiqueta(){
	char aux[TAM_ETIQ];
	snprintf(aux,TAM_ETIQ,"$l%d",num_etiq);
	return strdup(aux);
}


















