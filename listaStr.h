#ifndef _LISTASTR_H
#define _LISTASTR_H

typedef struct listaStr * listaStr;

listaStr crearListaStr();
char * insertarStr(listaStr * l, char * cadena);
void imprimirListaStr(listaStr l);
void borrarListaStr(listaStr l);

#endif
