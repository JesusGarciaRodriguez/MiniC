#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>


int regOcupado[10]={0};


op * crarOp(char* codOp, char* res, char* arg1, char* arg2){
//Malloc y to eso. sig a NULL

}

char * obtenerReg(){
	int i=0;
	while(i<10 && regOcupado[i])
		i++;
	if(i<10)
		return concati("$t",i);
	fprintf(stderr,"Error: No hay registros libres");
	exit(1);
}


void liberarReg(char* reg){
	regOcupado[reg[2]-'0']=0;
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

void imprimirCod(struct ops * cod){
}



