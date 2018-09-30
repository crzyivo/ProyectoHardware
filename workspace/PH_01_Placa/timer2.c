/*********************************************************************************************
* Fichero:		timer2.c
* Autor:
* Descrip:		funciones de control del timer2 del s3c44b0x
* Version:
*********************************************************************************************/

/*--- ficheros de cabecera ---*/
#include "timer2.h"
#include "44b.h"
#include "44blib.h"

/*--- variables globales ---*/
volatile unsigned int timer2_num_int=0;

/* declaración de función que es rutina de servicio de interrupción
 * https://gcc.gnu.org/onlinedocs/gcc/ARM-Function-Attributes.html */
void timer_ISR(void) __attribute__((interrupt("IRQ")));

/*--- codigo de las funciones ---*/
void timer_ISR(void)
{
	timer2_num_int++;

	/* borrar bit en I_ISPC para desactivar la solicitud de interrupción*/
	rI_ISPC |= BIT_TIMER2; // BIT_TIMER2 está definido en 44b.h y pone un uno en el bit 11 que correponde al Timer2
}

void timer2_inicializar(void)
{
	/* Configuraion controlador de interrupciones */
	rINTMOD = 0x0; // Configura las linas como de tipo IRQ
	rINTCON = 0x1; // Habilita int. vectorizadas y la linea IRQ (FIQ no)
	rINTMSK &= ~(BIT_TIMER2); // habilitamos en vector de mascaras de interrupcion el Timer2 (bits 26 y 13, BIT_GLOBAL y BIT_TIMER2 están definidos en 44b.h)

	/* Establece la rutina de servicio para TIMER2 */
	pISR_TIMER2 = (unsigned) timer_ISR;

	/* Configura el Timer2 */
	rTCFG0 = 0x00001100; // Preescalado del timer2 en bits [15:8] de TCFG0
	rTCFG1 = 0x0; // selecciona la entrada del mux que proporciona el reloj. La 00 corresponde a un divisor de 1/2.
	rTCNTB2 = 65535;// valor inicial de cuenta (la cuenta es descendente)
	rTCMPB2 = 12800 ;// valor de comparación
	//Timer control register, para timer2 bits [15:12] -> [15] auto-reload, [14] output inverter, [13] manual update, [12] start/stop
	/* establecer update=manual (bit 13), inverter=off (0 en bit 14) y auto-reload (bit 15)*/
	rTCON = 0x0000A000;
}

void timer2_empezar(void)
{
	/* iniciar timer2 (bit 12)*/
	rTCON = rTCON | 0x00001000;
}

unsigned int timer2_leer()
{

}

unsigned int timer2_parar(void)
{
	/*parar timer2, desactivamos bit 12 en TCON*/
	rTCON = rTCON & 0xffffEfff;
	return timer2_leer();
}

