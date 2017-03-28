#include "minic.h"
#include<stdio.h>
#include<stdlib.h>

//Funcion que implementa lex.yy.c
extern int yylex();
extern char *yytext;
extern int yyleng;
extern FILE * yyin;


int main(int argc, char * argv[]){
	//Comprobar que el parametro con el nombre del fichero está bien.
	if (argc !=2){
		fprintf(stderr,"Uso: %s fichero\n",argv[0]);
		exit(1);	
	}
	yyin=fopen(argv[1],"r");
	if (yyin==NULL){
		fprintf(stderr,"El archivo %s no existe\n",argv[1]);
		exit(1);	
	}
	int token;
	do{
		token=yylex();
		//if (token==ID)
			//printf("Longitud ID %d. ID: %s\n",yyleng,yytext);
	} while(token!=0);
	fclose(yyin);
}
