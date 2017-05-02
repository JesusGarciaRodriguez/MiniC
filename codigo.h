
#ifndef _CODIGO_H
#define _CODIGO_H


typedef struct ops{
	op * prim;
	op * ult;
} ops;

//Una funcion que enganche listas (comprobando los nulos y tal) que si no coñazo
typedef struct operacion{
	char * codOp;
	char * res;
	char * arg1;
	char * arg2;
	struct operacion * sig;
}	op;

op * crarOp(char* codOp, char* res, char* arg1, char* arg2);
char * obtenerReg();
void liberarReg(char* reg);
char * concatInt(char * pref, int i);
char * concatStr(char * pref, char* suf);
void imprimirCod(struct ops * cod);

#endif
