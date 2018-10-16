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
	//SF y SC se deben leer de la pila
	ldrsb r4,[fp,#4] //SF
	ldrsb r5,[fp,#8] //SC

	add r8,r4,r2 //FA = FA + SF
	add r7,r5,r3 //CA = CA + SC
	//Preparamos llamada a ficha valida, r0=tablero, r1=FA , r2=CA ,r3=@posicion_valida
	mov r0,r10
	mov r1,r8
	mov r2,r7
	mov r6,#0 //posicion_valida=0
	//strb r6,[sp,#-4]
	sub r3,sp,#4 //@posicion_valida
	mov r6,r3 //Nos guardamos la direccion para el retorno de la llamada

	bl ficha_valida
	//Volvemos de la funcion ficha_valida, casilla se encuentra en r0 y @posicion_valida en r4
	ldrb r3,[r6]
	cmp r3,#1 //posicion==1
	bne no_patron
	//cargamos color de la pila
	ldrb r6,[fp,#12] //r4=color
	cmp r0,r6 //casilla==color
	ldrb r0,[r9]
	bne llamada_recursiva
	cmp r0,#0 //longitud>0
	movgt r0,#1 //PATRON_ENCONTRADO
	movle r0,#0 //NO_HAY_PATRON
	b return_patron_volteo_arm_c

no_patron:
	mov r0,#0
	b return_patron_volteo_arm_c

llamada_recursiva:

	//ldrb r0,[r9]	//cargamos valor de longitud
	add r0,r0,#1	//*longitud=*longitud+1
	strb r0,[r9]

	mov r0,r10		//r0=@tablero
	mov r1,r9		//r1=@longitud
	mov r2,r8		//r2=FA
	mov r3,r7		//r3=CA
	/*
	strb r6,[sp]	//str SF
	strb r5,[sp,#4] //str SC
 	strb r4,[sp,#8] //str color
	*/
	stmdb sp, {r4-r6}
	bl patron_volteo_arm_c

return_patron_volteo_arm_c:
	ldmdb fp,{r4-r10,fp,sp,pc}
	bx lr

#################################################################################################################

#Funcion ficha_valida_arm
#################################################################################################################
.section .text
.global ficha_valida_arm //usados: r5,r6,r7,r8
ficha_valida_arm:
	mov ip, sp
	stmdb sp!, {r4-r10,fp, sp, lr, pc}
	sub fp, ip, #4
	mov r5, #8	//r5=DIM---> como accedo a la variable??
	mov r6, #0	//casilla vacia | valor minimo para indice de casilla
	mov r7, #1
	mul r8, r1,r5	//calculamos numero de casillas para acceso a la ficha del tablero
	add r8, r8, r2	//
	cmp r5,r1
	ble no_valido	//DIM <=f
	cmp r1,r7
	blt no_valido	//f<0
	cmp r5,r2
	ble no_valido	//DIM <=c
	cmp r2,r7
	blt no_valido	//c<0
	ldrb r9,[r0,r8,LSL#2]	//cargo en r9 tablero[f][c]--> multiplicar por 4
	cmp r9,r6 //tablero[f][c] != casilla_vacia
	beq no_valido
	strb r7,[r3]
 	mov r0,r9 //ficha =tablero[f][c]
 	b retorno

no_valido:
	strb r6,[r3]
	mov r0,r6

retorno:
	ldmdb fp,{r4-r10,fp,sp,pc}
	bx lr
.data



.end
#        END
