#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>


int regOcupado[10]={0};


op * crearOp(char* codOp, char* res, char* arg1, char* arg2){
	op* aux=malloc(sizeof(op));
	aux->codOp=strdup(codOp);
	aux->res=strdup(res);
	aux->arg1=strdup(arg1);
	aux->arg2=strdup(arg2);
	aux->sig=NULL;
	return aux;
}

char * obtenerReg(){
	int i=0;
	while(i<10 && regOcupado[i])
		i++;
	if(i<10)
		return concatInt("$t",i);
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



void imprimirCod(ops cod){
}

void concatenarListasOp(op* prim, op* ult,  ops* listas, int length){
	for(int i=0; i<(length-1); i++){
		if(listas[i].prim!=NULL){
			int j=i+1;
			while(j<length && listas[j].prim==NULL)
				j++;
			if(j<length)
				listas[i].ult->sig=listas[j].prim;
		}
	}
	int i=0;
	do{
		prim=listas[i].prim;
		i++;
	}while(i<length && prim==NULL);
	i=length-1;
	do{
		ult=listas[i].ult;
		i--;
	}while(i>=0 && ult==NULL);
}


