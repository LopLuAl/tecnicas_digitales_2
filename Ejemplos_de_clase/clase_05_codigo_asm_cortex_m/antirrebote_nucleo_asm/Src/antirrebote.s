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
.equ DEBOUNCE_TIME,	20

		.section	.text
		.align		2
 		.global		debounce_init, debounce_tarea

/****************************************/
/*	debounce_init 						*/
/*	Inicializa la máquina de estados.	*/
/*	pone todas las variables a cero		*/
/****************************************/
		.type		debounce_init, %function
debounce_init:
		PUSH	{R0, R1}
		MOVS	R0,#0
		LDR		R1,=estado
		STR		R0,[R1]
		LDR		R1,=debounce
		STR		R0,[R1]
		LDR		R1,=estado_boton
		STR		R0,[R1]
		POP		{R0, R1}
		BX		LR

/****************************************/
/*	debounce_tarea 						*/
/*	Recibe por R0 el estado del pulsador*/
/*	cero es presionado.					*/
/*  devuelvo por R0 estado_boton		*/
/****************************************/
		.type		debounce_tarea, %function
debounce_tarea:
		PUSH	{R1, R2, R3}
		//Leo la variable de estado.
		LDR		R1,=estado
		LDR 	R2,[R1]
debounce_estado_cero:
		CMP 	R2,#0
		BNE 	debounce_estado_uno
		//Ejecuto el código del estado cero.
		CMP 	R0,#0
		BNE 	debounce_salir
		//Si está presionado debounce=DEBOUNCE_TIME y voy a estado_uno.
debounce_carga:
		LDR 	R1,=debounce
		LDR 	R0,=#DEBOUNCE_TIME
		STR 	R0,[R1]
		ADDS 	R2, #1
		B 		debounce_salir
debounce_estado_uno:
		CMP 	R2,#1
		BNE 	debounce_estado_dos
		LDR		R1,=debounce
		LDR 	R3,[R1]
		SUBS 	R3,#1
		STR 	R3,[R1]	//debounce--
		CMP		R3,#0
		BNE		debounce_salir
		CMP		R0,#0	//Se venció el antirrebote y está presionado.
		BNE		debounce_estado_uno_2
		LDR		R1,=estado_boton
		LDR		R3,[R1]
		MOVS	R0,#1
		EORS	R3,R0
		STR		R3,[R1]
		ADDS	R2,#1
		B		debounce_salir
debounce_estado_uno_2:
		SUBS	R2,#1
		B		debounce_salir
debounce_estado_dos:
		CMP 	R2,#2
		BNE 	debounce_estado_tres
		CMP 	R0,#0
		BEQ 	debounce_salir
		B		debounce_carga
debounce_estado_tres:
		CMP	R2, #3
		BNE debounce_salir
		LDR		R1,=debounce
		LDR 	R3,[R1]
		SUBS 	R3,#1
		STR 	R3,[R1]
		CMP		R3,#0
		BNE		debounce_salir
		CMP		R0,#0
		BEQ		debounce_estado_tres_2
		MOVS	R2,#0
		B		debounce_salir
debounce_estado_tres_2:
		SUBS	R2,#1
debounce_salir:
		LDR	R1,=estado
		STR R2,[R1]
		LDR R1,=estado_boton
		LDR R0,[R1]
		POP		{R1, R2, R3}
		BX		LR
.end
