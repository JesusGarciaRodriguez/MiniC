#ifndef _CODIGO_H
#define _CODIGO_H

typedef struct operacion{
	char * codOp;
	char * res;
	char * arg1;
	char * arg2;
	struct operacion * sig;
}	op;

typedef struct listaOp{
	op * prim;
	op * ult;
} ops;

op * crearOp(char* codOp, char* res, char* arg1, char* arg2);
char * obtenerReg();
void liberarReg(char* reg);
char * concatInt(char * pref, int i);
char * concatStr(char * pref, char* suf);
void imprimirCodigo(ops cod);
char * nuevaEtiqueta();
void concatenarListasOp(ops* SS, ops* listas, int length);

#endif
