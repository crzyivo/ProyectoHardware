/*********************************************************************************************
* Fichero:	main.c
* Autor:
* Descrip:	punto de entrada de C
* Version:  <P4-ARM.timer-leds>
*********************************************************************************************/

#define EMU
/*--- ficheros de cabecera ---*/
#include "8led.h"
#include "button.h"
#include "led.h"
#include "timer.h"
#include "timer2.h"
#include "44blib.h"
#include "44b.h"
#include "latido.h"
#include "botones_antirebotes.h"
/*--- variables globales ---*/


/*--- codigo de funciones ---*/

void reverse_main();
//////////////////////////////////////////////////////////////////////
//	Funcion que comprueba el correcto funcionamiento del timer2
//	para ello realiza varias mediciones usando la funcion Delay,
//  comprobandose a mano que los resultados son ranozablemente aproximados
void test_timer2(){
	unsigned int tiempos[8];	//Array para anotar tiempos del timer2
	unsigned int tiempo_medido_1ms = 0;
	unsigned int tiempo_medido_10ms = 0;
	unsigned int tiempo_medido_1s = 0;
	unsigned int tiempo_medido_10s = 0;
	timer2_empezar();

	tiempos[0] = timer2_leer();
	Delay(10); //1 ms
	tiempos[1] = timer2_leer();
	tiempo_medido_1ms = tiempos[1]-tiempos[0];

	tiempos[2] = timer2_leer();
	Delay(100); //10 ms
	tiempos[3] = timer2_leer();
	tiempo_medido_10ms = tiempos[3]-tiempos[2];

	tiempos[4] = timer2_leer();
	Delay(10000); //1 s
	tiempos[5] = timer2_leer();
	tiempo_medido_1s = tiempos[5]-tiempos[4];

	tiempos[6] = timer2_leer();
	Delay(100000); //10 s
	tiempos[7] = timer2_leer();
	tiempo_medido_10s = tiempos[7]-tiempos[6];
}
void Main(void)
{
	/* Inicializa controladores */
	sys_init();         // Inicializacion de la placa, interrupciones y puertos
	//timer_init();	    // Inicializacion del temporizador
	button_iniciar();	// inicializamos los pulsadores. Cada vez que se pulse se ver� reflejado en el 8led
	D8Led_init();       // inicializamos el 8led
	timer2_inicializar();
	inicio_antirebotes();
	latido_inicializar();


	/* Valor inicial de los leds */
	//leds_off();
	//test_timer2();
	//Dejamos los leds apagados
	//led1_on();
	//Iniciar reversi8;
	//reversi8();
	//button_empezar(button_callback);
	//Codigo para cambiar los leds segun el timer
	reversi_main();
}

void reversi_main(){
	while(1){
		//Por ahora nada
	}
}
