#include "listaStr.h"
#include <stdlib.h>
#include <string.h>
#include<stdio.h>

int num_cadenas=1;

//Solo copia
struct listaStr {
	char * cadena;
	char * etiq;
	struct listaStr * sig;
};


listaStr crearListaStr()
{
	return NULL;
}


char * insertarStr(listaStr * l, char * cadena)
{
	struct listaStr * aux=(struct listaStr *)malloc(sizeof(struct listaStr));
	aux->cadena=strdup(cadena);
	char etiq[10];
	snprintf(etiq,10,"$str%d",num_cadenas);
	aux->etiq=strdup(etiq);
	aux->sig=*l;
	*l=aux;
	num_cadenas++;
	return aux->etiq;
}

void imprimirListaStr(listaStr l){
	for(listaStr aux=l; aux!=NULL; aux=aux->sig){
		printf("%s:\n", aux->etiq);
		printf("\t.asciiz %s\n",aux->cadena);
	} 
}


void borrarListaStr(listaStr l)
{
	struct listaStr * aux=l;
	while(aux!=NULL)
	{
		l=aux->sig;
		free(aux->cadena);
		free(aux->etiq);
		free(aux);
		aux=l;	
	}
	
}



























