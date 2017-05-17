%{
#include "codigo.h"
#include <stdio.h>
#include "minic.tab.h"
#include <math.h>

int comienzo_comentario;
extern int num_errores;
%}
	
%x comentario

 
%%
 
func 	{
		return FUNC;
	}

var	{
			return VAR;
	}

let 	{
			return LET;
	}

if	{
			return IF;
	}

else	{
			return ELSE;
	}

while	{
			return WHILE;
		}

print	{
			return PRINT;		
	}

read	{
			return READ;		
	}
do	{	
			return DO;
	}
";"	{
			return PTOCOMA;		
	}

"+"	{
			return MAS;		
	}

"-"	{
			return MENOS;		
	}

"*"	{
			return POR;		
	}

"/"	{
			return ENTRE;		
	}

"="	{
			return IGUAL;		
	}

","	{
			return COMA;		
	}

")"	{
			return CPAR;		
	}
"("	{
			return APAR;		
	}

"{"	{
			return ALLAVE;		
	}

"}"	{
			return CLLAVE;		
	}

"<"	{
			return MENOR;		
	}

">"	{
			return MAYOR;		
	}

"!"	{
			return NEG;		
	}

"||"	{
			return OR;		
	}

"&&"	{
			return AND;		
	}


[a-zA-Z_][a-zA-Z_0-9]*	{
						if(yyleng>16){
							printf("*** Error léxico (linea %d): identificador demasiado largo. %s ***\n",yylineno,yytext);
							num_errores++;
						}else			
							yylval.str=strdup(yytext);
						return ID;
					}

[0-9]+	{
			long entero=atol(yytext);
			if(entero>pow(2,31)){
				printf("*** Error léxico (linea %d): constante demasiado grande. %s ***\n",yylineno,yytext);
				num_errores++;
			}else
				yylval.str=strdup(yytext);
			return ENT;
		}

[ \t\n\r]+ 	{ /* Ignoramos */ }

"//".* 		{ /* Ignoramos */ } 

"/*"	{ BEGIN(comentario); comienzo_comentario=yylineno; yymore();}


\"([^"\r\n]|\\\")*$	{
					printf("*** Error léxico (linea %d):COMILLAS SIN CERRAR: %s ***\n",yylineno,yytext);						
					return CADENA;
				}

\"([^"\r\n]|\\\")*\" { 	
					yylval.str=strdup(yytext);				
					return CADENA;	
				}


<comentario>([^*]|[*]+[^*/])* { yymore(); }
<comentario>[*]+"/"  { BEGIN(INITIAL); }
<comentario><<EOF>> { printf("*** COMENTARIO SIN CERRAR (abierto en la linea %d) ***\n",comienzo_comentario); return 0; }

[^a-zA-Z0-9,*_";+/=(){} \t\n\r-]+ 	{
			printf("*** Error léxico (linea %d): %s ***\n",yylineno,yytext);
			num_errores++;
			return ID;
	}


















