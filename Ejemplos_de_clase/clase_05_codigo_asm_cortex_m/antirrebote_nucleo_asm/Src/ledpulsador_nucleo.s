		.syntax		unified
		.cpu		cortex-m0
		.thumb

/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ RCC_AHB1ENR, 	0x40023830	// Registros para habilitar el clock de GPIOC
.equ GPIOCEN,		0x4			// bit para habilitar clk en GPIOC
.equ GPIOAEN,		0x1			// bit para habilitar clk en GPIA
.equ PORTA_MODER,	0x40020000	// Registro para setear la función de cada pin del GPIO
.equ PORTA_BSRR,	0x40020018	// Registro para escritura tipo SET - RESET
.equ PORTC_IDR,		0x40020810	// Registro de entrada

		.section	.text
		.align		2
 		.global		board_init, led_set, led_reset, b1_read

/****************************************/
/*	Función led_init. 				 	*/
/*	Inicializa El LED					*/
/****************************************/
		.type	board_init, %function
board_init:
		PUSH	{R0, R1, R2, R3, LR}	// Mando a la pila los registros que modifico y LR
		LDR		R0,	=#RCC_AHB1ENR		// Dirección de memoria para habilitar clk en GPIO
		LDR		R3, [R0]				// Leo el registro
		LDR		R1, =#GPIOAEN			//
		LDR		R2, =#GPIOCEN			// Bits para habilitar PORTC y PORTA
		ORRS	R3, R1					//
		ORRS	R3, R2					// Habilito los bits en cuestión
		STR		R3, [R0]				// Escribo el registro.
		LDR		R0, =#PORTA_MODER
		LDR		R3, [R0]
		MOVS	R1, #0x01
		LSLS	R1, R1, #10
		ORRS	R3, R1
		STR		R3, [R0]				//Leo la configuración de GPIOA y pongo A5 como salida
		POP		{R0, R1, R2, R3, PC}

/****************************************/
/*	Función led_set. 				 	*/
/*	Setea el led						*/
/****************************************/
		.type	led_set, %function
led_set:
		PUSH	{R0, R1}			// Mando a la pila todos los registros que modifico
		MOVS	R0,#1				// R1   = 0x01
		LSLS	R0,R0,#5			// R0 <<= 5
		ldr 	R1, =#PORTA_BSRR   	// Escribo la dirección de memoria para setear GPIOA
		STR 	R0, [R1]          	// Escribo el puerto de salida
		POP		{R0, R1}			// Repongo los registros que toqué.
		BX		LR					// return

/****************************************/
/*	Función led_reset. 				 	*/
/*	Resetea el led						*/
/****************************************/
		.type	led_reset, %function
led_reset:
		PUSH	{R0, R1}			// Mando a la pila todos los registros que modifico
		MOVS	R0,#1				// R1   = 0x01
		LSLS	R0,R0,#21			// R0 <<= 21
		LDR 	R1, =#PORTA_BSRR   	// Escribo la dirección de memoria para setear GPIOA
		STR 	R0, [R1]          	// Escribo el puerto de salida
		POP		{R0, R1}			// Repongo los registros que toqué.
		BX		LR					// return


/****************************************/
/*	Función b1_read. 				 	*/
/*	Lee el pulsador B1					*/
/****************************************/
		.type	b1_read, 	%function
b1_read:
		PUSH	{R1, R2, LR}		// Mando lo que modifico a la pila
		LDR		R2, =#1				// R2 = 1 (se puede usar MOVS para 1)
		LSLS	R2, R2,#13			// R2 = R2 <<13
		LDR		R1, =#PORTC_IDR		// R1 dirección de memoria del registro para leer el GPIO
		LDR		R0, [R1]			// Me traigo el valor del registro a R1
		ANDS	R0, R0, R2			// Enmascaro R0 = R0 & (1<<13)
		POP		{R1, R2, PC}		// Devuelvo por R0 el valor del pin y repongo registros
