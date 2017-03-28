%{
#include "calculadora.tab.h"
#include <stdio.h>
int yycolumn=1;
#define YY_USER_ACTION yylloc.first_line=yylloc.last_line=yylineno; yylloc.first_column=yycolumn; yylloc.last_column=yycolumn+yyleng-1; yycolumn+=yyleng;
%}

D [0-9]

%%

"+"		return MAS;
"-" 	return MENOS;
"*" 	return MULT;
"/" 	return DIV;
{D}+ 	{ yylval.num = atoi(yytext); return ENT; }
";" 	return PYC;
"("     return PARI;
")"     return PARD;
"^"		return EXP;
"="		return EQUAL;	
[a-zA-Z_][a-zA-Z_0-9]* { yylval.str=strdup(yytext); return ID;}
[ \t\r]+ ;        //Ignorar
"\n"	yycolumn=1;
. 	    {printf("Error léxico en línea %d: %s\n",yylineno,yytext);	
        }
