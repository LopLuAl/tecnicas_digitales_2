		.syntax		unified
		.cpu		cortex-m0
		.thumb
/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ PORTC_ODR,		0x4001100C	// .equ es similar a  #define
.equ GPIOC_CHR, 	0x40011004	// Puerto GPIOC
.equ RCC_APB2ENR, 	0x40021018	// Registros

.equ GPIOA_CRL,		0x40010800	// GPIOA - Port configuration register low
.equ GPIOA_ODR,		0x4001080C
.equ PORTA_IDR, 	0x40010808	// GPIOA - Port input data register
		.section	.text
		.align		2
 		.global		gpio_init, led_set, delay
/****************************************/
/*	Función led_init. 				 	*/
/*	Inicializa El LED					*/
/****************************************/
		.type	gpio_init, %function
gpio_init:
		PUSH	{R1, R2, R3, LR}		// Mando a la pila los registros que modifico y LR

		LDR		R1, =0x1
		LSLS	R1,R1,#2
		LDR 	R2,=#RCC_APB2ENR
		STR		R3,[R2]
		ORRS	R3,R2,R3
		LDR		R1, =0x1
		LSLS	R1,R1,#2
		ORRS	R3,R2,R3

		LDR 	R1, =(0b11 << 20)
		LDR 	R2, =#GPIOC_CHR
		STR 	R1, [R2]

		/*PUERTO A 0 - 7 */
		/*A0-A3 -> ENTRADA - PULL UP INTERNO
		  A4-A7 -> SALIDA*/
		LDR		R1, =#0x11118888
		LDR 	R2, =#GPIOA_CRL
		STR		R1, [R2]

		LDR 	R1, =#0x0F
		LDR 	R2, =#GPIOA_ODR
		STR		R1,[R2]

		POP		{R1, R2, R3, PC}

/****************************************/
/*	Función led_set. 				 	*/
/*	Setea el led en funcion de R0		*/
/****************************************/
		.type	led_set, %function
led_set:
		PUSH	{R0, R1, R2}		// Mando a la pila todos los registros que modifico
		MVNS	R0,R0				// R0   = ~R0
		MOVS	R1,#1				// R1   = 0x01
		ANDS	R0,R0,R1			// R0 & = 0x01
		LSLS	R0,R0,#13			// R0 <<= 13
		ldr 	R2, =#PORTC_ODR   	// Escribo la dirección de memoria para setear GPIOC
		STR 	R0, [R2]          	// Escribo el puerto de salida
		POP		{R0, R1, R2}		// Repongo los registros que toqué.
		BX		LR					// return

/****************************************/
/*	Función delay. 				 		*/
/*	Recibe por R0 la demora				*/
/****************************************/
		.type	delay, %function
delay:
		PUSH	{R0, LR}			// Guardo el parámetro y LR en la pila.
delay_dec:
        SUBS	R0, 1				//
        BNE		delay_dec			// while(--R0);
		POP		{R0, PC}			// repongo R0 y vuelvo.



 .end
