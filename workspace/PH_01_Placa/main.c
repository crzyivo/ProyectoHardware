/*********************************************************************************************
* Fichero:	main.c
* Autor:
* Descrip:	punto de entrada de C
* Version:  <P4-ARM.timer-leds>
*********************************************************************************************/

/*--- ficheros de cabecera ---*/
#include "8led.h"
#include "button.h"
#include "led.h"
#include "timer.h"
#include "44blib.h"
#include "44b.h"

/*--- variables globales ---*/


/*--- codigo de funciones ---*/
void Main(void)
{
	/* Inicializa controladores */
	sys_init();         // Inicializacion de la placa, interrupciones y puertos
	timer_init();	    // Inicializacion del temporizador
	Eint4567_init();	// inicializamos los pulsadores. Cada vez que se pulse se ver� reflejado en el 8led
	D8Led_init();       // inicializamos el 8led


	/* Valor inicial de los leds */
	leds_off();
	//Dejamos los leds apagados
	//led1_on();

	//Iniciar reversi8;
	reversi8();

/*	Codigo para cambiar los leds segun el timer
 * while (1)
	{
		// Cambia los leds con cada interrupcion del temporizador
		if (switch_leds == 1)
		{
			leds_switch();
			switch_leds = 0;
		}
	}*/
}
