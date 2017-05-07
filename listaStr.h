#ifndef _LISTASTR_H
#define _LISTASTR_H

typedef struct listaStr * listaStr;
// Solo copia
listaStr crearLista();
void insertarStr(listaStr * l, char * cadena);
void imprimirListaStr(listaStr l);
void borrarListaStr(listaStr l);

#endif
