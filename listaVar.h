#ifndef _LISTAVAR_H
#define _LISTAVAR_H

typedef struct listaRep * listaVar;

listaVar crearListaVar();
void insertarVar(listaVar * l, char * nombre, int tipo, int tipoDeDatos);
int consultarTipoVar(listaVar l,char * nombre);
void imprimirListaVar(listaVar l);
void borrarListaVar(listaVar l);

#endif
