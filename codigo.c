#include "codigo.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define TAM_ETIQ 10

int regOcupado[10]={0};
int num_etiq=1;


op * crearOp(char* codOp, char* res, char* arg1, char* arg2){
	op* aux=malloc(sizeof(op));
	if (codOp!=NULL)
		aux->codOp=strdup(codOp);
	else
		aux->codOp=NULL;
	if (res!=NULL)
		aux->res=strdup(res);
	else
		aux->res=NULL;	
	if (arg1!=NULL)
		aux->arg1=strdup(arg1);
	else
		aux->arg1=NULL;	
	if (arg2!=NULL)
		aux->arg2=strdup(arg2);
	else
		aux->arg2=NULL;
	aux->sig=NULL;
	return aux;
}

char * obtenerReg(){
	int i=0;
	while(i<10 && regOcupado[i])
		i++;
	if(i<10){
		regOcupado[i]=1;
		return concatInt("$t",i);
	}
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

void imprimirCuadrupla(op* cuad){
	if(strcmp(cuad->codOp,"etiq")==0)
		printf("%s:\n",cuad->res);
	else{
		printf("\t%s",cuad->codOp);
		if(cuad->res!=NULL)	printf(" %s",cuad->res);
		if(cuad->arg1!=NULL)	printf(", %s",cuad->arg1);
		if(cuad->arg2!=NULL)	printf(", %s",cuad->arg2);
		printf("\n");
	}	
}


void imprimirCodigo(ops cod){
	if(cod.prim!=NULL)
	for(op * aux=cod.prim; aux!=NULL; aux=aux->sig){
		imprimirCuadrupla(aux);	
	}
}


char * nuevaEtiqueta(){
	char aux[TAM_ETIQ];
	snprintf(aux,TAM_ETIQ,"$l%d",num_etiq);
	num_etiq++;
	return strdup(aux);
}

void concatenarListasOp(ops* SS,  ops* listas, int length){
	
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
		SS->prim=listas[i].prim;
		i++;
	}while(i<length && SS->prim==NULL);
	i=length-1;
	do{
		SS->ult=listas[i].ult;
		i--;
	}while(i>=0 && SS->ult==NULL);
}


