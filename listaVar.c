#include "listaVar.h"
#include <stdlib.h>
#include <string.h>
#include<stdio.h>

struct listaRep {
	char * nombre;
	int tipo;	// 1 es VAR y 0 es LET
	struct listaRep * sig;
};


listaVar crearListaVar()
{
	return NULL;
}

struct listaRep * buscarNodo(listaVar l, char * nombre)
{
	struct listaRep * aux =l;
	while(aux !=NULL)
	{
		if(strcmp(aux->nombre,nombre)==0)
			return aux;
		aux=aux->sig;
	}
	return NULL;
}

void insertarVar(listaVar * l, char * nombre, int tipo)
{
	struct listaRep * aux=(struct listaRep *)malloc(sizeof(struct listaRep));
	aux->nombre=nombre;
	aux->tipo=tipo;
	aux->sig=*l;
	*l=aux;
}

int consultarTipoVar(listaVar l,char * nombre)
{
	struct listaRep * aux=buscarNodo(l,nombre);
	if(aux!=NULL)
		return aux->tipo;
	else return -1;
	
}


void imprimirListaVar(listaVar l){
	for(listaVar aux=l; aux!=NULL; aux=aux->sig){
		printf("_%s:\n", aux->nombre);
		printf("\t.word 0\n");
	} 
}


void borrarListaVar(listaVar l)
{
	struct listaRep * aux=l;
	while(aux!=NULL)
	{
		free(aux->nombre);
		aux=aux->sig;
		free(l);
		l=aux;	
	}
	
}



























