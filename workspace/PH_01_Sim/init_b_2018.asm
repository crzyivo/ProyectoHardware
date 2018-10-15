.text
#        ENTRY            		/*  mark the first instruction to call */
.global	start
start:
.arm /*indicates that we are using the ARM instruction set */
#------standard initial code
# --- Setup interrupt / exception vectors 
      B       Reset_Handler 
/* In this version we do not use the following handlers */
#######################################################################################################
#-----------Undefined_Handler: 
#      B       Undefined_Handler 
#----------SWI_Handler: 
#      B       SWI_Handler 
#----------Prefetch_Handler: 
#      B       Prefetch_Handler 
#----------Abort_Handler: 
#      B       Abort_Handler 
#         NOP      /* Reserved vector */ 
#----------IRQ_Handler: 
#      B       IRQ_Handler 
#----------FIQ_Handler: 
#      B       FIQ_Handler 
#######################################################################################################
# Reset Handler:
# the processor starts executing this code after system reset       
#######################################################################################################
Reset_Handler:  
#        
        MOV     sp, #0x4000      /*  set up stack pointer (r13) */ 

.extern     reversi8
        ldr         r5, = reversi8
        mov         lr, pc 
        bx          r5 


stop: 	
 		B     	stop    	/*  end of program */

#################################################################################################################		
#Funcion patron_volteo_arm_c
#################################################################################################################
.section .text
.global patron_volteo_arm_c
patron_volteo_arm_c:
	mov ip, sp
	stmdb sp!, {r4-r10,fp, sp, lr, pc}
	sub fp, ip, #4
	//Guardamos los parametros iniciales que vamos a modificar en otros registros
	mov r10,r0 //@tablero
	mov r9,r1 //@longitud
	//Inicializamos variables con las que vamos a trabajar
	mov r4,#0 ;posicion_valida=0
	//SF y SC se deben leer de la pila
	ldrsb r6,[fp,#4] //SF
	ldrsb r5,[fp,#8] //SC

	add r8,r6,r2 //FA = FA + SF
	add r7,r5,r3 //CA = CA + SC
	//Preparamos llamada a ficha valida, r0=tablero, r1=FA , r2=CA ,r3=@posicion_valida
	mov r0,r10
	mov r1,r8
	mov r2,r7
	strb r4,[sp,#-4]
	sub r3,sp,#4 //@posicion_valida
	mov r4,r3 //Nos guardamos la direccion para el retorno de la llamada

	bl ficha_valida
	//Volvemos de la funcion ficha_valida, casilla se encuentra en r0 y @posicion_valida en r4
	ldrb r3,[r4]
	cmp r3,#1 //posicion==1
	bne no_patron
	//cargamos color de la pila
	ldrb r4,[fp,#12] //r4=color
	cmp r0,r4 //casilla==color
	bne llamada_recursiva
	ldrb r0,[r9]
	cmp r0,#0 //longitud>0
	movgt r0,#1 //PATRON_ENCONTRADO
	movle r0,#0 //NO_HAY_PATRON
	b return_patron_volteo_arm_c

no_patron:
	mov r0,#0
	b return_patron_volteo_arm_c

llamada_recursiva:

	ldrb r0,[r9]	//cargamos valor de longitud
	add r0,r0,#1	//*longitud=*longitud+1
	strb r0,[r9]

	mov r0,r10		//r0=@tablero
	mov r1,r9		//r1=@longitud
	mov r2,r8		//r2=FA
	mov r3,r7		//r3=CA
	strb r6,[sp]	//str SF
	strb r5,[sp,#4] //str SC
 	strb r4,[sp,#8] //str color

	bl patron_volteo_arm_c

return_patron_volteo_arm_c:
	ldmdb fp,{r4-r10,fp,sp,pc}
	bx lr
#################################################################################################################
.data



.end
#        END
