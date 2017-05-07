#ifndef _LISTAETIQ_H
#define _LISTAETIQ_H

typedef struct listaRep * listaEtiq;

listaEtiq crearLista();
void insertarEtiq(listaEtiq * l, char * nombre, int tipo);
int consultarTipoEtiq(listaEtiq l,char * nombre);
void borrarLista(listaEtiq l);

#endif
