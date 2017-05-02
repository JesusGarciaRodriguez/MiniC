%{
#include <stdio.h>
// Importante orden así #include "codigo.h"
#include "minic.tab.h"
#include <math.h>

int comienzo_comentario;
int nErrores;
%}
	
%x comentario

 
%%
 
func 	{
		//printf("FUNC\n");
		return FUNC;
	}

var	{
			//printf("VAR\n");
			return VAR;
	}

let 	{
			//printf("LET\n");
			return LET;
	}

if	{
			//printf("IF\n");
			return IF;
	}

else	{
			//printf("ELSE\n");
			return ELSE;
	}

while	{
			//printf("WHILE\n");
			return WHILE;
		}

print	{
			//printf("PRINT\n");
			return PRINT;		
	}

read	{
			//printf("READ\n");
			return READ;		
	}
";"	{
			//printf("PTOCOMA\n");
			return PTOCOMA;		
	}

"+"	{
			//printf("MAS\n");
			return MAS;		
	}

"-"	{
			//printf("MENOS\n");
			return MENOS;		
	}

"*"	{
			//printf("POR\n");
			return POR;		
	}

"/"	{
			//printf("ENTRE\n");
			return ENTRE;		
	}

"="	{
			//printf("IGUAL\n");
			return IGUAL;		
	}

","	{
			//printf("COMA\n");
			return COMA;		
	}

")"	{
			//printf("CPAR\n");
			return CPAR;		
	}
"("	{
			//printf("APAR\n");
			return APAR;		
	}

"{"	{
			//printf("ALLAVE\n");
			return ALLAVE;		
	}

"}"	{
			//printf("CLLAVE\n");
			return CLLAVE;		
	}

[a-zA-Z_][a-zA-Z_0-9]*	{
						if(yyleng>16){
							printf("*** Error léxico (linea %d): identificador demasiado largo. %s ***\n",yylineno,yytext);
							nErrores++;
						}else			
							//printf("ID: %s\n", yytext);
						yylval.str=strdup(yytext);
						return ID;
					}

[0-9]+	{
			long entero=atol(yytext);
			if(entero>pow(2,31)){
				printf("*** Error léxico (linea %d): constante demasiado grande. %s ***\n",yylineno,yytext);
				nErrores++;
			}else
				//printf("ENT: %s\n", yytext);
			yylval.str=strdup(yytext);
			return ENT;
		}

[ \t\n\r]+ 	{ /* Ignoramos */ }

"//".* 		{ /* Ignoramos */ } 

"/*"	{ comienzo_comentario=yylineno; BEGIN(comentario); yymore();}


\"([^"\r\n]|\\\")*$	{
					printf("*** Error léxico (linea %d):COMILLAS SIN CERRAR: %s ***\n",yylineno,yytext);						
					return CADENA;
				}

\"([^"\r\n]|\\\")*\" { 	
					//printf("CADENA ENTRECOMILLADA: %s\n",yytext);						
					return CADENA;	
				}

[^a-zA-Z0-9,*_";+/=(){} \t\n\r-]+ 	{
			printf("*** Error léxico (linea %d): %s ***\n",yylineno,yytext);
			nErrores++;
			return ID;
	}

<comentario>"/*"([^*]|[*]+[^*/])*[*]+"/" { yymore(); }
<comentario>[*]+"/"  { /*printf("COMENTARIO:\n%s\n", yytext);*/BEGIN(INITIAL); }
<comentario><<EOF>> { printf("*** COMENTARIO SIN CERRAR (abierto en la linea %d) ***\n",comienzo_comentario); return 0; }
























