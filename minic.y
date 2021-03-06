%{
#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "listaVar.h"
#include "listaStr.h"

extern int yylex();
int yyerror(const char * msg);
extern int yylineno;
char * nuevaEtiqueta();
listaVar lVar;
listaStr lStr;
int tipo;
char bufErr[128];
int num_errores=0;
%}

%union {
	char * str;
	ops mips; 
}

%token FUNC VAR LET IF ELSE WHILE PRINT READ APAR CPAR PTOCOMA COMA MAS MENOS POR ENTRE IGUAL ALLAVE CLLAVE DO MENOR MAYOR NEG OR AND 
%token<str> ID ENT CADENA
%type<mips> expression statement statement_list print_list print_item read_list asig identifier_list declarations

%left NEG 
%left IGUAL MENOR MAYOR
%left AND OR
%left MAS MENOS 
%left POR ENTRE	
%nonassoc UMENOS 

%expect 1 

%%

program: 		FUNC ID APAR CPAR ALLAVE declarations statement_list CLLAVE 	{ 
																					if(num_errores==0){
																						printf(".data\n\n"); 
																						imprimirListaStr(lStr);
																						imprimirListaVar(lVar); 
																						printf("\n.text\n.globl main\nmain:\n"); 
																						imprimirCodigo($6);
																						imprimirCodigo($7);
																						printf("\tjr $ra\n"); 
																					}
																					else
																						printf("Se han detectado errores. No se generará código\n");
																				} 
			;

declarations:	declarations VAR {tipo=1;} identifier_list PTOCOMA 	{ 
																		if(num_errores==0){
																			ops tablaListas[2]={$1,$4};
																			concatenarListasOp(&$$,tablaListas,2);						
																		}	
																	} 
			|	declarations LET {tipo=0;} identifier_list PTOCOMA { 
																		if(num_errores==0){
																			ops tablaListas[2]={$1,$4};
																			concatenarListasOp(&$$,tablaListas,2);						
																		}	
																	} 
			|	/*Lambda*/ { $$.prim=NULL; $$.ult=NULL; }
			| 	declarations VAR error PTOCOMA { num_errores++;}
			| 	declarations LET error PTOCOMA { num_errores++;}
			;

identifier_list: asig { $$=$1;}
			|	identifier_list COMA asig 	{
												if(num_errores==0){
													ops tablaListas[2]={$1,$3};
													concatenarListasOp(&$$,tablaListas,2);						
												}	
											}
			;

asig:			ID {
						if(consultarTipoVar(lVar,$1)!=-1){
							snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
							yyerror(bufErr);			
							num_errores++;
						}			
						else 
							insertarVar(&lVar,$1,tipo);
						if(num_errores==0){
							$$.prim=NULL; $$.ult=NULL;
						}
					}
			| 	ID IGUAL expression {			
										if(consultarTipoVar(lVar,$1)!=-1){
											snprintf(bufErr,128,"La variable %s ya ha sido declarada",$1);
											yyerror(bufErr);	
											num_errores++;		
										}						
										else 
											insertarVar(&lVar,$1,tipo);
										if(num_errores==0){
											$$.prim=$3.prim; 
											$3.ult->sig=crearOp("sw",$3.ult->res,concatStr("_",$1),NULL);	
											$$.ult=$3.ult->sig;
											liberarReg($3.ult->res);
										}
									}
			;

statement_list:	statement_list statement 	{ 
												if(num_errores==0){
													ops tablaListas[2]={$1,$2};
													concatenarListasOp(&$$,tablaListas,2);	
												}
											}
			|	/*lambda*/{ $$.prim=NULL; $$.ult=NULL;}	
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
																			char* etiquetaElse=nuevaEtiqueta();
																			char* etiquetaIf=nuevaEtiqueta();
																			ops aux1;
																			aux1.prim=crearOp("beqz",$3.ult->res,etiquetaElse,NULL);
																			aux1.ult=aux1.prim;
																			ops aux2;
																			aux2.prim=crearOp("b",etiquetaIf,NULL,NULL);
																			aux2.ult=crearOp("etiq",etiquetaElse,NULL,NULL);
																			aux2.prim->sig=aux2.ult;
																			ops aux3;
																			aux3.prim=crearOp("etiq",etiquetaIf,NULL,NULL);
																			aux3.ult=aux3.prim;
																			ops tablaListas[6]={$3,aux1,$5,aux2,$7,aux3};
																			concatenarListasOp(&$$,tablaListas,6);
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
															concatenarListasOp(&$$,tablaListas,4);
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
																concatenarListasOp(&$$,tablaListas,5);
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
																concatenarListasOp(&$$,tablaListas,4);
																liberarReg($5.ult->res);
															}
														}
			|	PRINT print_list PTOCOMA { if(num_errores==0) $$=$2;}
			|	READ read_list PTOCOMA { if(num_errores==0) $$=$2;}
			| 	error CLLAVE { num_errores++;} 
			| 	error PTOCOMA { num_errores++;}
			;
			
print_list:		print_item { if(num_errores==0) $$=$1; }
			|	print_list COMA print_item 	{
												if(num_errores==0){
													ops tablaListas[2]={$1,$3};
													concatenarListasOp(&$$,tablaListas,2);						
												}	
											}
			;

print_item:		expression 	{
								if(num_errores==0){
									$$.prim=$1.prim;
									$1.ult->sig=crearOp("move","$a0",$$.ult->res,NULL);
									$1.ult->sig->sig=crearOp("li","$v0","1",NULL);
									$1.ult->sig->sig->sig=crearOp("syscall",NULL,NULL,NULL);
									$$.ult=$1.ult->sig->sig->sig;
									liberarReg($1.ult->res);
								}
							}
			|	CADENA 	{ 	
							if(num_errores==0){
								char * etiqueta=insertarStr(&lStr,$1);
								$$.prim=crearOp("la","$a0",etiqueta,NULL);
								$$.prim->sig=crearOp("li","$v0","4",NULL);
								$$.prim->sig->sig=crearOp("syscall",NULL,NULL,NULL);
								$$.ult=$$.prim->sig->sig;
							}
						}
			;

read_list:		ID { 
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
								$$.prim=crearOp("li","$v0","5",NULL);
								$$.prim->sig=crearOp("syscall",NULL,NULL,NULL);
								$$.prim->sig->sig=crearOp("sw","$v0",concatStr("_",$1),NULL);
								$$.ult=$$.prim->sig->sig;
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
										if(num_errores==0){
													ops aux;
													aux.prim=crearOp("li","$v0","5",NULL);
													aux.prim->sig=crearOp("syscall",NULL,NULL,NULL);
													aux.prim->sig->sig=crearOp("sw","$v0",concatStr("_",$3),NULL);
													aux.ult=aux.prim->sig->sig;
													ops tablaListas[2]={$1,aux};
													concatenarListasOp(&$$,tablaListas,2);						
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
														$3.ult->sig=crearOp("div",obtenerReg(),$1.ult->res,$3.ult->res);
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
			|	NEG expression	{ 
													if(num_errores==0){
														$$.prim=$2.prim;
														$2.ult->sig=crearOp("not",obtenerReg(),$2.ult->res,NULL);
														$$.ult=$2.ult->sig;
														liberarReg($2.ult->res);
													}
												}
			|	expression MENOR expression 	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$3.prim;
														$3.ult->sig=crearOp("slt",obtenerReg(),$1.ult->res,$3.ult->res);
														$$.ult=$3.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($3.ult->res);
													}
												}
			|	expression MAYOR expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$3.prim;
														$3.ult->sig=crearOp("sgt",obtenerReg(),$1.ult->res,$3.ult->res);
														$$.ult=$3.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($3.ult->res);
													}
												}
			|	expression MENOR IGUAL expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$4.prim;
														$4.ult->sig=crearOp("sle",obtenerReg(),$1.ult->res,$4.ult->res);
														$$.ult=$4.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($4.ult->res);
													}
												}
			|	expression MAYOR IGUAL expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$4.prim;
														$4.ult->sig=crearOp("sge",obtenerReg(),$1.ult->res,$4.ult->res);
														$$.ult=$4.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($4.ult->res);
														}
													}
			|	expression IGUAL IGUAL expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$4.prim;
														$4.ult->sig=crearOp("seq",obtenerReg(),$1.ult->res,$4.ult->res);
														$$.ult=$4.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($4.ult->res);
														}
													}
			|	expression NEG IGUAL expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$4.prim;
														$4.ult->sig=crearOp("sne",obtenerReg(),$1.ult->res,$4.ult->res);
														$$.ult=$4.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($4.ult->res);
													}
												}
			|	expression AND expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$3.prim;
														$3.ult->sig=crearOp("and",obtenerReg(),$1.ult->res,$3.ult->res);
														$$.ult=$3.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($3.ult->res);
													}
												}

			|	expression OR expression	{ 
													if(num_errores==0){
														$$.prim=$1.prim;
														$1.ult->sig=$3.prim;
														$3.ult->sig=crearOp("or",obtenerReg(),$1.ult->res,$3.ult->res);
														$$.ult=$3.ult->sig;														
														liberarReg($1.ult->res);
														liberarReg($3.ult->res);
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
							$$.prim=crearOp("li",obtenerReg(),$1,NULL); 
							$$.ult=$$.prim; 
						}
					}
			;
%%
/* Rutinas C */
int yyerror(const char * msg){
	fprintf(stderr,"%s (linea %d)\n",msg,yylineno);
}



















