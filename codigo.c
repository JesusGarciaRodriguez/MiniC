#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>


int regOcupado[10]={0};
char * obtenerReg(){
	int i=0;
	while(i<10 && regOcupado[i])
		i++;
	if(i<10)
		return concati("$t",i);
	fprintf(stderr,"No hay registros libres");
	exit(1);
}

char * concatInt(char * pref, int i){
	char aux[64];
	snprintf(aux,64,"%s%d",pref,i);
	return strdup(aux);
}

char * concatStr(char * pref, char* suf){
	char aux[64];
	snprintf(aux,64,"%s%s",pref,suf);
	return strdup(aux);
}



