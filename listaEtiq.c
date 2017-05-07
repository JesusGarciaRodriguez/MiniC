#include "listaEtiq.h"
#include <stdlib.h>
#include <string.h>
#include<stdio.h>

struct listaRep {
	char * nombre;
	int tipo;	// 1 es Etiq y 0 es LET
	struct listaRep * sig;
};


listaEtiq crearListaEtiq()
{
	return NULL;
}

struct listaRep * buscarNodo(listaEtiq l, char * nombre)
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

void insertarEtiq(listaEtiq * l, char * nombre, int tipo)
{
	struct listaRep * aux=(struct listaRep *)malloc(sizeof(struct listaRep));
	aux->nombre=nombre;
	aux->tipo=tipo;
	aux->sig=*l;
	*l=aux;
}

int consultarTipoEtiq(listaEtiq l,char * nombre)
{
	struct listaRep * aux=buscarNodo(l,nombre);
	if(aux!=NULL)
		return aux->tipo;
	else return -1;
	
}


void borrarListaEtiq(listaEtiq l)
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



























