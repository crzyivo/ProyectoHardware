/*********************************************************************************************
* Fichero:	8led.c
* Autor:
* Descrip:	Funciones de control del display 8-segmentos
* Version:
*********************************************************************************************/

/*--- ficheros de cabecera ---*/
#include "8led.h"
#include "44b.h"
#include "44blib.h"

/*--- variables globales del módulo ---*/
/* tabla de segmentos */
static int
Symbol[size_8led] = { cero, uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve, A, B, C, D, E, F, blank};

/*--- código de las funciones ---*/
void D8Led_init(void)
{
#ifndef EMU
	/* Estado inicial del display con todos los segmentos iluminados
	   (buscar en los ficheros de cabecera la direccion implicada) */
	LED8ADDR = (unsigned char) cero;
#endif
}

void D8Led_symbol(int value)
{
#ifndef EMU
	/* muestra el Symbol[value] en el display (analogo al caso anterior) */
	if ((value >= 0) && (value < size_8led)) {
		LED8ADDR = (unsigned char) Symbol[value];
	}
#endif
}
