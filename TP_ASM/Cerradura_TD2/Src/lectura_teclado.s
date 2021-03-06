		.syntax		unified
		.cpu		cortex-m0
		.thumb

/****************************************/
/*	Defino variables en RAM				*/
/****************************************/
	.section	.bss
	.comm	estado		,4
	.comm	debounce	,4
	.comm	estado_boton,4

/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ PORTC_ODR,		0x4001100C	// .equ es similar a  #define
.equ GPIOC_CHR, 	0x40011004	// Puerto GPIOC
.equ RCC_APB2ENR, 	0x40021018	// Registros

.equ GPIOA_CRL,		0x40010800	// GPIOA - Port configuration register low
.equ GPIOA_ODR,		0x4001080C
.equ PORTA_IDR, 	0x40010808	// GPIOA - Port input data register

/*CONSTANTES DE TECLADO MATRICIAL*/
.equ TECLA_0,	0b1010111
.equ TECLA_1, 	0b1101110
.equ TECLA_2,	0b1011110
.equ TECLA_3,	0b0111110
.equ TECLA_4,	0b1101101
.equ TECLA_5,	0b1011101
.equ TECLA_6,	0b0111101
.equ TECLA_7, 	0b1101011
.equ TECLA_8, 	0b1011011
.equ TECLA_9, 	0b0111011
.equ TECLA_NUM,	0b0110111
.equ TECLA_AST,	0b1100111



.equ LOOP_COMPARE, 	0x2ffff		// Demora por software.



		.section	.text
		.align		2
 		.global		lectura_teclado, numero_combinacion_init,numero_combinacion

		.type	lectura_teclado, %function
lectura_teclado:
		PUSH	{R1, R2, R3, LR}		// Mando lo que modifico a la pila
		// Pongo en '0' la primer COLUMNA
		LDR		R1, =#0x3F
		LDR 	R2, =#GPIOA_ODR
		STR		R1, [R2]

		LDR		R1, =#PORTA_IDR
		LDR		R3,[R1]
		LDR 	R2,=#0xFF
		ANDS	R3,R3,R2
		CMP 	R3,#TECLA_3
		BEQ 	TECLA_3_PRESIONADA
		CMP 	R3,#TECLA_6
		BEQ 	TECLA_6_PRESIONADA
		CMP 	R3,#TECLA_9
		BEQ 	TECLA_9_PRESIONADA
		CMP 	R3,#TECLA_NUM
		BEQ 	TECLA_NUM_PRESIONADA

		// Pongo en '0' la SEGUNDA COLUMNA
		LDR		R1, =#0x5F
		LDR 	R2, =#GPIOA_ODR
		STR		R1, [R2]

		LDR		R1, =#PORTA_IDR
		LDR		R3,[R1]
		LDR 	R2,=#0xFF
		ANDS	R3,R3,R2
		CMP 	R3,#TECLA_2
		BEQ 	TECLA_2_PRESIONADA
		CMP 	R3,#TECLA_5
		BEQ 	TECLA_5_PRESIONADA
		CMP 	R3,#TECLA_8
		BEQ 	TECLA_8_PRESIONADA
		CMP 	R3,#TECLA_0
		BEQ 	TECLA_0_PRESIONADA

		// Pongo en '0' la TERCERA COLUMNA
		LDR		R1, =#0x6F
		LDR 	R2, =#GPIOA_ODR
		STR		R1, [R2]

		LDR		R1, =#PORTA_IDR
		LDR		R3,[R1]
		LDR 	R2,=#0xFF
		ANDS	R3,R3,R2
		CMP 	R3,#TECLA_1
		BEQ 	TECLA_1_PRESIONADA
		CMP 	R3,#TECLA_4
		BEQ 	TECLA_4_PRESIONADA
		CMP 	R3,#TECLA_7
		BEQ 	TECLA_7_PRESIONADA
		CMP 	R3,#TECLA_AST
		BEQ 	TECLA_AST_PRESIONADA


		LDR		R0,	=#0xff // Si no presione ninguna tecla, cargo con ff
		POP	{R1, R2, R3,PC}		// Mando lo que modifico a la pila

TECLA_0_PRESIONADA:
		LDR		R0, =#0
		POP		{R1, R2, R3, PC}
TECLA_1_PRESIONADA:
		LDR		R0, =#1
		POP		{R1, R2, R3, PC}
TECLA_2_PRESIONADA:
		LDR		R0, =#2
		POP		{R1, R2, R3, PC}
TECLA_3_PRESIONADA:
		LDR		R0, =#3
		POP		{R1, R2, R3, PC}
TECLA_4_PRESIONADA:
		LDR		R0, =#4
		POP		{R1, R2, R3, PC}
TECLA_5_PRESIONADA:
		LDR		R0, =#5
		POP		{R1, R2, R3, PC}
TECLA_6_PRESIONADA:
		LDR		R0, =#6
		POP		{R1, R2, R3, PC}
TECLA_7_PRESIONADA:
		LDR		R0, =#7
		POP		{R1, R2, R3, PC}
TECLA_8_PRESIONADA:
		LDR		R0, =#8
		POP		{R1, R2, R3, PC}
TECLA_9_PRESIONADA:
		LDR		R0, =#9
		POP		{R1, R2, R3, PC}
TECLA_NUM_PRESIONADA:
		LDR		R0, =#10
		POP		{R1, R2, R3, PC}
TECLA_AST_PRESIONADA:
		LDR		R0, =#11
		POP		{R1, R2, R3, PC}


		.type		numero_combinacion_init, %function
numero_combinacion_init:
		PUSH	{R0, R1}
		MOVS	R0,#1
		LDR		R1,=estado_combinacion
		STR		R0,[R1]
		POP		{R0, R1}
		BX		LR

		.type	numero_combinacion, %function
numero_combinacion:
		PUSH	{R1, R2, R3, R4, LR}
		/*
			estado_combinacion	-> VARIABLE QUE GUARDA LOS ESTADOS DE LA MAQUINA DE ESTADOS
			combinacion  		-> NUMERO DE COMBINACION FORMADO
			estado_boton 		-> VALOR DEL DIGITO FILTRADO DEL TECLADO MATRICIAL
		*/

		LDR 	R1,=estado_combinacion
		LDR 	R2,=combinacion
		LDR		R3,=estado_boton 	//Direccion de la varible donde guardo la tecla filtrada del matricial

		LDR		R3,[R3]				//Cargo en R3 el contenido de R3 (tecla filtrada del matricial)
		CMP		R3,0xFF				//Si no presione ninguna tecla, salgo de la rutina de armado de la combinacion
		BEQ		SALIR

		/**********PRENDO Y APAGO EL LED PARA INDICAR QUE INGRESE EL NUMERO************/
		MOVS	R0,#1
		BL		led_set
		//Demora
		LDR		R0,=#LOOP_COMPARE
		BL		delay
		//Apago el led
		MOVS	R0,#0
		BL		led_set
		/**********PRENDO Y APAGO EL LED PARA INDICAR QUE INGRESE EL NUMERO************/

		LDR  	R4,[R1] // cargo en r4 el conteniod apuntado por r1
		CMP		R4, #1
		BEQ		ESTADO_1
		CMP		R4, #2
		BEQ		ESTADO_2
		CMP		R4, #3
		BEQ		ESTADO_3
		CMP		R4, #4
		BEQ		ESTADO_4


ESTADO_1: // Aca ingrese el primer digito y lo multiplico por 1000
		LDR  	R4, =#1000
		MULS 	R3,R3,R4  //estado_boton = estado_boton*1000
		STR  	R3,[R2]   //combinacion = estado_boton
		LDR  	R4, =#2   //Cargo el siguiente estado y espero que el usuario ingrese una nueva tecla
		STR	 	R4,[R1]   //
		B    	SALIR

ESTADO_2:
		LDR  	R4, =#100
		MULS 	R3,R3,R4  //estado_boton = estado_boton*100
		LDR	 	R4,[R2]   //R4 = *combinacion
		ADDS 	R3,R3,R4 // estado_boton = estado_boton*100+combinacion
		STR  	R3,[R2]  // combinacion = estado_boton
		LDR  	R4, =#3   //Cargo el siguiente estado y espero que el usuario ingrese una nueva tecla
		STR	 	R4,[R1]   //
		B 		SALIR


ESTADO_3:
		LDR  	R4, =#10
		MULS 	R3,R3,R4  //estado_boton = estado_boton*10
		LDR	 	R4,[R2]   //R4 = *combinacion
		ADDS 	R3,R3,R4 // estado_boton = estado_boton*10+combinacion
		STR  	R3,[R2]  // combinacion = estado_boton
		LDR  	R4, =#4   //Cargo el siguiente estado y espero que el usuario ingrese una nueva tecla
		STR	 	R4,[R1]   //
		B 		SALIR

ESTADO_4:
		LDR  	R4, =#1
		MULS 	R3,R3,R4  //estado_boton = estado_boton*1
		LDR	 	R4,[R2]   //R4 = *combinacion
		ADDS 	R3,R3,R4 // estado_boton = estado_boton*1+combinacion
		STR  	R3,[R2]  // combinacion = estado_boton
		LDR  	R4, =#1   //Cargo el siguiente estado y espero que el usuario ingrese una nueva tecla
		STR	 	R4,[R1]   //
		B 		SALIR


SALIR:
		POP		{R1, R2, R3, R4, PC}
.end
