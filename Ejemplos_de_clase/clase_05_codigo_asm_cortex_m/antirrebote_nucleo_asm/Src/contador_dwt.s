		.syntax		unified
		.cpu		cortex-m0
		.thumb

/****************************************/
/*	Defino constantes de programa		*/
/****************************************/
.equ DWT_CONTROL, 	0xE0001000
.equ DWT_CYCCNT,	0xE0001004

		.section	.text
		.align		2
 		.global		dwt_init, dwt_reset, dwt_read

/****************************************/
/*	Función dwt_init. 				 	*/
/*	Inicializa el contador dwt			*/
/****************************************/
		.type	dwt_init, %function
dwt_init:
		PUSH	{R0, R1, R2}
		MOVS	R0,#1
		LDR		R1,=#DWT_CONTROL
		LDR		R2,[R1]
		ORRS	R2,R2,R0
		STR		R2,[R1]
		POP		{R0, R1, R2}
		BX		LR

/****************************************/
/*	Función dwt_reset. 				 	*/
/*	Pone DWT a cero						*/
/****************************************/
		.type	dwt_reset, %function
dwt_reset:
		PUSH	{R0, R1}
		EORS	R0,R0,R0
		LDR		R1,=#DWT_CYCCNT
		STR		R0,[R1]
		POP		{R0, R1}
		BX		LR

/****************************************/
/*	Función dwt_read. 				 	*/
/*	Pone en R0 el valor de DWT			*/
/****************************************/
		.type	dwt_read, %function
dwt_read:
		PUSH	{R1}
		LDR		R1,=#DWT_CYCCNT
		LDR		R0,[R1]
		POP		{R1}
		BX		LR
