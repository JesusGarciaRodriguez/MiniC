
#ifndef _CODIGO_H
#define _CODIGO_H


typedef struct ops{
	op * prim;
	op * ult;
} ops;


typedef struct operacion{
	char * codOp;
	char * res;
	char * arg1;
	char * arg2;
	struct operacion * sig;
}	op;

char * obtenerReg();
char * concatInt(char * pref, int i);
char * concatStr(char * pref, char* suf);

#endif
