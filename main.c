#include "minic.h"
#include "listaVar.h"
#include "listaStr.h"
#include<stdio.h>
#include<stdlib.h>

extern FILE* yyin;
extern int yyparse();
extern int yydebug;
extern listaVar lVar;
extern listaStr lStr;

int main(int argc, char** argv){

    if(argc!=2){
        printf("Uso: %s ficher\n", argv[0]);
        exit(1);
    }

    yyin=fopen(argv[1],"r");
    if(yyin==NULL){
        printf("Error, no se puede abrir %s \n", argv[1]);
        exit(2);
    }
	yydebug=0;
	lStr=crearListaStr();
	lVar=crearListaVar();
    yyparse();
	borrarListaVar(lVar);
	borrarListaStr(lStr);
    fclose(yyin);
}
